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
~/dotfiles github.com/kivattt/dotfiles
~/tutils   github.com/kivattt/tutils
~/fen      github.com/kivattt/fen

~/main              The folder the terminal will start at
~/main/etc/torrents Pirated movies/music
~/main/projects     Code projects, repos
```
