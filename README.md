## My configuration files
`autoexec.cfg` is a config file for Team Fortress 2

Use `lxappearance` to customize system-wide GTK theme (requires restarting to show up in firefox, pavucontrol etc.)

Intellij IDEA theme: [Darcula Pitch Black](https://plugins.jetbrains.com/plugin/14059-darcula-pitch-black)

## Home folder structure
```
~/dotfiles   github.com/kivattt/dotfiles
~/tutils2    github.com/kivattt/tutils2
~/fen        github.com/kivattt/fen
~/rainbowize github.com/kivattt/rainbowize

~/main              The folder the terminal will start at
~/main/wallpapers   Desktop background images
~/main/etc/torrents Pirated movies/music
~/main/projects     Code projects, repos
```

## Installing the JetBrains Mono font (for XTerm and i3wm)
```console
cd ~/Downloads
mkdir JetBrainsMono
cd JetBrainsMono
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip
unzip JetBrainsMono-2.304.zip
mv fonts/ttf fonts/JetBrainsMono
sudo cp -r fonts/JetBrainsMono /usr/share/fonts/truetype
rm -rf ~/Downloads/JetBrainsMono
```

## Installing Go on Linux
Based on https://go.dev/doc/install

[Download the latest .tar.gz release](https://go.dev/dl/), then:
```console
cd ~/Downloads
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go*.linux-amd64.tar.gz
```

Now add this line to the end of `/etc/profile`:
```
export PATH=$PATH:/usr/local/go/bin
```
Log out (Alt+E in i3wm) then back in again, do `go version` to verify it successfully installed

## Profiling C/C++ with valgrind + kcachegrind
```console
# Remember to build your code with the -g flag for debug symbols
valgrind --tool=callgrind ./your-c-or-cpp-program
kcachegrind callgrind.out.1387577 # The file generated by valgrind
```

## Profiling C/C++/Go with Intel VTune profiler
[Install with apt](https://www.intel.com/content/www/us/en/developer/tools/oneapi/vtune-profiler-download.html?operatingsystem=linux&linux-install-type=apt), described below
```console
sudo apt update
sudo apt install -y gpg-agent wget
wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list
sudo apt update
sudo apt install intel-oneapi-vtune
```

Now, self-check and run `vtune-gui`
```console
source /opt/intel/oneapi/vtune/latest/env/vars.sh
cd /opt/intel/oneapi/vtune/latest/bin64

# Run a self-check
sudo ./vtune-self-checker.sh

xhost + # This is required to allow root to connect to X11
sudo ./vtune-gui
```
