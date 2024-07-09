// I hate this

package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"math"
	"net"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"time"

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

func DisksNameAndMountPoints() ([][2]string, error) {
	out, err := exec.Command("lsblk", "-o", "NAME,MOUNTPOINT").Output()
	if err != nil {
		return nil, err
	}

	ret := [][2]string{}

	lastDiskName := ""
	for _, line := range strings.Split(string(out), "\n") {
		lineSplitSpaces := strings.Split(line, " ")
		if !(strings.HasPrefix(line, " ") || strings.HasPrefix(line, "├") || strings.HasPrefix(line, "└")) {
			lastDiskName = lineSplitSpaces[0]
		}

		if len(lineSplitSpaces) < 2 {
			continue
		}

		mountPoint := lineSplitSpaces[len(lineSplitSpaces)-1]

		if mountPoint == "/" || strings.HasPrefix(mountPoint, "/mnt/") {
			ret = append(ret, [2]string{lastDiskName, mountPoint})
		}
	}

	return ret, nil
}

func date() string {
	now := time.Now()
	left :=  now.Format("2006-01-02")
	middle := now.Format("Jan 2")
	right := now.Format("15:04:05")
	return left + " <span foreground=\"#aaaaaa\">" + middle + "</span> " + right
}

type Memory struct {
	MemTotal int
	MemFree int
	MemAvailable int
	MemCached int
	MemSReclaimable int
	MemShmem int
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


func ReadMemoryStats() Memory {
    file, err := os.Open("/proc/meminfo")
    if err != nil {
        panic(err)
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
    return res
}

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

			ip = "<span foreground=\"#00ff00\">" + ip + "</span>"
		}

		textList = append(textList, "<span foreground=\"#aaaaaa\">IP:</span> " + ip)

		disks, err := DisksNameAndMountPoints()
		if err != nil {
			panic(err)
		}
		for _, disk := range disks {
			bytes, err := FreeDiskSpaceBytes(disk[1])
			if err != nil {
				continue
			}
			textList = append(textList, "<span foreground=\"#aaaaaa\">" + disk[0] + "</span>: " + BytesToHumanReadableUnitString(bytes, 3))
		}

		memory := ReadMemoryStats()
		usedMem := (memory.MemTotal - memory.MemAvailable) * 1000
		totalMem := memory.MemTotal * 1000

		memoryColor := "#ffffff"
		if float32(usedMem)/float32(totalMem) > 0.95 {
			memoryColor = "#ff0000"
		} else if float32(usedMem) / float32(totalMem) > 0.85 {
			memoryColor = "#ffff00"
		}

		textList = append(textList, "<span foreground=\"#aaaaaa\">RAM:</span> " + BytesToHumanReadableUnitString(uint64(usedMem), 1) + "/" + BytesToHumanReadableUnitString(uint64(totalMem), 1))
		textList = append(textList, date())

		fmt.Println(",[")
		for i, v := range textList {
			data := map[string]any{
				"full_text": v,
				"separator_block_width": 20,
				"markup": "pango",
			}

			if strings.HasPrefix(v, "RAM: ") {
				data["full_text"] = "<span foreground=\"" + memoryColor + "\">" + data["full_text"].(string) + "</span>"
			}

			json, err := json.Marshal(data)
			if err != nil {
				panic(err)
			}
			fmt.Println(string(json))
			if i != len(textList) - 1 {
				fmt.Println(",")
			}
		}
		fmt.Println("]")

		// So the clock always shows a multiple of 5 seconds
		timeToSleep := 5 - time.Now().Second()%5
		time.Sleep(time.Duration(timeToSleep) * time.Second)
	}
}
