// I hate this

package main

import (
	"bufio"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"net"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"time"

	"github.com/distatus/battery"
	"golang.org/x/sys/unix"
)

func FreeDiskSpaceBytes(path string) (uint64, error) {
	var stat unix.Statfs_t
	err := unix.Statfs(path, &stat)
	return uint64(stat.Bavail) * uint64(stat.Bsize), err
}

// Trims the last decimals up to maxDecimals, does nothing if maxDecimals is less than 0, e.g -1
func trimLastDecimals(numberString string, maxDecimals int) string {
	if maxDecimals < 0 {
		return numberString
	}

	dotIndex := strings.Index(numberString, ".")
	if dotIndex == -1 {
		return numberString
	}

	return numberString[:min(len(numberString), dotIndex+maxDecimals+1)]
}

// If maxDecimals is less than 0, e.g -1, we show the exact size down to the byte
// https://en.wikipedia.org/wiki/Byte#Multiple-byte_units
func BytesToHumanReadableUnitString(bytes uint64, maxDecimals int) string {
	unitValues := []float64{
		math.Pow(10, 3),
		math.Pow(10, 6),
		math.Pow(10, 9),
		math.Pow(10, 12),
		math.Pow(10, 15),
		math.Pow(10, 18), // Largest unit that fits in 64 bits
	}

	unitStrings := []string{
		"kB",
		"MB",
		"GB",
		"TB",
		"PB",
		"EB",
	}

	if bytes < uint64(unitValues[0]) {
		return strconv.FormatUint(bytes, 10) + " B"
	}

	for i, v := range unitValues {
		if bytes >= uint64(v) {
			continue
		}

		lastIndex := max(0, i-1)
		return trimLastDecimals(strconv.FormatFloat(float64(bytes)/unitValues[lastIndex], 'f', -1, 64), maxDecimals) + " " + unitStrings[lastIndex]
	}

	return trimLastDecimals(strconv.FormatFloat(float64(bytes)/unitValues[len(unitValues)-1], 'f', -1, 64), maxDecimals) + " " + unitStrings[len(unitStrings)-1]
}

func DisksNameAndSizeAndMountPoints() ([][3]string, error) {
	out, err := exec.Command("lsblk", "-bo", "NAME,SIZE,MOUNTPOINT").Output()
	if err != nil {
		return nil, err
	}

	ret := [][3]string{}

	lastDiskName := ""
	for _, line := range strings.Split(string(out), "\n") {
		lineSplitSpaces := strings.Split(line, " ")
		if !(strings.HasPrefix(line, " ") || strings.HasPrefix(line, "├") || strings.HasPrefix(line, "└")) {
			lastDiskName = lineSplitSpaces[0]
		}

		if len(lineSplitSpaces) < 2 {
			continue
		}

		size := lineSplitSpaces[len(lineSplitSpaces)-2]
		mountPoint := lineSplitSpaces[len(lineSplitSpaces)-1]

		if mountPoint == "/" || strings.HasPrefix(mountPoint, "/mnt/") {
			ret = append(ret, [3]string{lastDiskName, size, mountPoint})
		}
	}

	return ret, nil
}

func dateText(now time.Time) string {
	left := now.Format("Mon Jan 2")
	right := now.Format("2006-01-02")

	color := dimTextColor
	// Check for april fools day
	if strings.HasSuffix(left, "Apr 1") || strings.HasSuffix(left, "Mar 31") {
		//color = "#ff0000"
		color = "#9f3efa"
	}

	return "<span foreground=\"" + color + "\">" + left + "</span> " + right
}

func timeText(now time.Time) string {
	return "<span foreground=\"" + whiteTextColor + "\" size=\"15pt\" weight=\"180\">" + now.Format("15:04:05") + "</span>"
}

func batteryText(batteries []*battery.Battery) (string, error) {
	if batteries == nil || len(batteries) < 1 {
		return "", errors.New("No battery")
	}

	var builder strings.Builder
	builder.WriteString("<span foreground=\"#36a4f7\">")

	for _, b := range batteries {
		if b.Full == 0 {
			return "", errors.New("No battery")
		}

		builder.WriteString(b.State.String())
		builder.WriteString(" " + strconv.FormatFloat(b.Current/b.Full*100, 'f', 1, 64) + "%")
	}
	builder.WriteString("</span>")
	return builder.String(), nil
}

type Memory struct {
	MemTotal        int
	MemFree         int
	MemAvailable    int
	MemCached       int
	MemSReclaimable int
	MemShmem        int
}

func parseLine(raw string) (key string, value int) {
	text := strings.ReplaceAll(raw[:len(raw)-2], " ", "")
	keyValue := strings.Split(text, ":")
	return keyValue[0], toInt(keyValue[1])
}

func toInt(raw string) int {
	if raw == "" {
		return 0
	}
	res, err := strconv.Atoi(raw)
	if err != nil {
		panic(err)
	}
	return res
}

func ReadMemoryStats() (Memory, error) {
	file, err := os.Open("/proc/meminfo")
	if err != nil {
		return Memory{}, err
	}
	defer file.Close()

	bufio.NewScanner(file)
	scanner := bufio.NewScanner(file)
	res := Memory{}
	for scanner.Scan() {
		key, value := parseLine(scanner.Text())
		switch key {
		case "MemTotal":
			res.MemTotal = value
		case "MemFree":
			res.MemFree = value
		case "MemAvailable":
			res.MemAvailable = value
		case "Cached":
			res.MemCached = value
		case "SReclaimable":
			res.MemSReclaimable = value
		case "Shmem":
			res.MemShmem = value
		}
	}
	return res, nil
}

var whiteTextColor = "#dddddd"
var dimTextColor = "#777777"

func main() {
	fmt.Println("{\"version\":1}")
	fmt.Println("[")
	fmt.Println("[]")

	for i := 0; ; i++ {
		textList := []string{}

		interfaces, err := net.Interfaces()
		ip := "<span foreground=\"red\">no IP</span>"
		if err == nil {
			for _, i := range interfaces {
				addrs, _ := i.Addrs()
				for _, addr := range addrs {
					switch v := addr.(type) {
					case *net.IPNet:
						ip = v.IP.String()
					case *net.IPAddr:
						ip = v.IP.String()
					}
				}
			}
		}

		if ip == "::1" {
			ip = ""
		}
		otherIP, _ := exec.Command("ip", "route", "get", "1").Output()
		otherIPSplit := strings.Split(strings.ReplaceAll(string(otherIP), "  ", ""), " ")
		otherIPStr := otherIPSplit[max(0, len(otherIPSplit)-5)]
		if otherIPStr != "" {
			ip += ", " + otherIPStr
		}

		textList = append(textList, "<span foreground=\""+dimTextColor+"\">IP:</span> <span foreground=\"#35d462\">"+ip+"</span>")

		disks, err := DisksNameAndSizeAndMountPoints()
		if err != nil {
			disks = [][3]string{
				{
					"disk",
					"250000000000", // 250 GB max space as a placeholder
					"/",
				},
			}
		}
		for _, disk := range disks {
			bytesMax, _ := strconv.Atoi(disk[1])
			bytesFree, err := FreeDiskSpaceBytes(disk[2])
			if err != nil {
				continue
			}

			diskFreeColor := whiteTextColor
			if float32(bytesFree)/float32(bytesMax) < 0.1 {
				diskFreeColor = "#ffff00"
			} else if float32(bytesFree)/float32(bytesMax) < 0.025 {
				diskFreeColor = "#ff0000"
			}
			textList = append(textList, "<span foreground=\""+dimTextColor+"\">"+disk[0]+":</span> <span foreground=\""+diskFreeColor+"\">"+BytesToHumanReadableUnitString(bytesFree, 1)+"</span>")
		}

		memoryColor := whiteTextColor
		memory, err := ReadMemoryStats()
		if err == nil {
			usedMem := (memory.MemTotal - memory.MemAvailable) * 1000
			totalMem := memory.MemTotal * 1000

			if float32(usedMem)/float32(totalMem) > 0.95 {
				memoryColor = "#ff0000"
			} else if float32(usedMem)/float32(totalMem) > 0.85 {
				memoryColor = "#ffff00"
			}

			textList = append(textList, "RAM: "+BytesToHumanReadableUnitString(uint64(usedMem), 1)+"/"+BytesToHumanReadableUnitString(uint64(totalMem), 1))
		}

		now := time.Now()
		textList = append(textList, dateText(now))
		batteries, _ := battery.GetAll()
		theBatteryText, err := batteryText(batteries)
		if err == nil {
			textList = append(textList, theBatteryText)
		}
		textList = append(textList, timeText(now))

		fmt.Println(",[")
		for i, v := range textList {
			if strings.HasPrefix(v, "RAM: ") {
				v = "<span foreground=\"" + dimTextColor + "\">RAM:</span> <span foreground=\"" + memoryColor + "\">" + v[len("RAM: "):] + "</span>"
			}

			data := map[string]any{
				"full_text":             "<span size=\"11pt\" weight=\"semibold\" foreground=\"" + whiteTextColor + "\">" + v + "</span>",
				"separator_block_width": 20,
				"markup":                "pango",
			}

			json, err := json.Marshal(data)
			if err != nil {
				panic(err)
			}
			fmt.Println(string(json))
			if i != len(textList)-1 {
				fmt.Println(",")
			}
		}
		fmt.Println("]")

		// So the clock always shows a multiple of 5 seconds
		timeToSleep := 5 - time.Now().Second()%5
		time.Sleep(time.Duration(timeToSleep) * time.Second)
	}
}
