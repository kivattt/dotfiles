## My configuration files
`autoexec.cfg` is my config file for Team Fortress 2

To use the JetBrains Mono font with XTerm, run this:
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

## Home folder structure
```
~/dotfiles   github.com/kivattt/dotfiles
~/tutils     github.com/kivattt/tutils
~/fen        github.com/kivattt/fen
~/rainbowize github.com/kivattt/rainbowize

~/main              The folder the terminal will start at
~/main/wallpapers   Desktop background images
~/main/etc/torrents Pirated movies/music
~/main/projects     Code projects, repos
```

Use `lxappearance` to customize system-wide GTK theme (requires restarting to show up in firefox, pavucontrol etc.)

## How to install Go on Linux
Based on https://go.dev/doc/install

[Download the latest .tar.gz release](https://go.dev/dl/), then:
```console
cd ~/Downloads
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.22.3.linux-amd64.tar.gz
```

Now add this line to the end of `/etc/profile`:
```
export PATH=$PATH:/usr/local/go/bin
```
Log out and back in again, do `go version` to verify it successfully installed
