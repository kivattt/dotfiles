export EDITOR=nvim

stty erase \^H

# Make Ctrl+s not freeze the terminal
[[ $- == *i* ]] && stty -ixon

clear
cd ~/main

git_branch() {
	git branch --show-current 2> /dev/null
}

# $USER isn't set in Termux for whatever reason
if [ -z $USER ]; then
	export USER=$(whoami)
fi

rainbowizepath=~/rainbowize
if test -x $rainbowizepath/rainbowize; then
	alias rainbowize="$rainbowizepath/rainbowize"
	export PS1="\[\033[1m\]$(~/rainbowize/rainbowize -fn $USER) \[\033[0m\]\033[0;37m\w \[\033[0;35m\]\$(git_branch)\n\[\033[0;31m\033[0m\]\[\033[0;37m\]$\[\033[0m\] "
else
	export PS1="\[\033[0;32m\]\u \[\033[0m\]\033[0;37m\w \[\033[0;35m\]\$(git_branch)\n\[\033[0;31m\033[0m\]\[\033[0;37m\]$\[\033[0m\] "
	echo -e "\e[0;31mrainbowize missing! Install: https://github.com/kivattt/rainbowize"
fi

#---------#
# Aliases #
#---------#
alias q=exit

alias vim="$EDITOR"
alias v="$EDITOR"
alias b="$EDITOR ~/.bashrc"
alias vr="$EDITOR ~/.config/nvim/init.lua"
alias fr="$EDITOR ~/.config/fen/config.lua"

alias p=cat
alias lowercase="tr [:upper:] [:lower:]"
alias uppercase="tr [:lower:] [:upper:]"
alias lower=lowercase
alias upper=uppercase

if type uniq > /dev/null 2> /dev/null; then
	printf "" # No-op
else
	alias uniq="sort -u"
fi

alias makewords="\\grep -o -E '\w+'"
alias s="xset dpms force off"
alias l="ls -1 --color"
alias sl="ls -A1 --color"
alias cls="clear; ls -1 --color"
alias csl="clear; ls -A1 --color"
alias cl="clear"
alias cll="cd .."
alias r="ranger"
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias xpidof="xprop _NET_WM_PID | awk '\$NF != \"found.\"{print \$NF}'"

alias octave="octave --force-gui"

#-----------------------------------#
# My terminal file manager, fen     #
#-----------------------------------#
if command -v fen > /dev/null; then
	alias r="fen"
else
	printf "\e[0;31mfen missing! Install: https://github.com/kivattt/fen\n"
fi

#------------------------------------#
# My coreutils replacements, tutils2 #
#------------------------------------#
tutils2path=~/tutils2/bin
if test -d $tutils2path; then
	# If you like setting fire to your insides for fun, uncomment the line below
	#export PATH=$tutils2path:$PATH

	# These are a bunch of aliases because we don't want to mess with shell scripts that expect specific coreutils behaviour
	alias ls="$tutils2path/ls"
	alias pwd="$tutils2path/pwd"
	alias cat="$tutils2path/cat"
	alias p="$tutils2path/cat"
	alias hex="$tutils2path/hex"
	alias xxd="$tutils2path/xxd"
	alias ascii="$tutils2path/ascii"
	alias countchars="$tutils2path/countchars"
	alias bytes="$tutils2path/bytes"

	# Overriding the previous ls aliases since tutils2 ls doesn't work with the same arguments
	alias l="$tutils2path/ls --directories-first --sort-by=modified"
	alias sl="$tutils2path/ls --all --directories-first --sort-by=modified"
	alias cls="clear; $tutils2path/ls --directories-first --sort-by=modified"
	alias csl="clear; $tutils2path/ls --all --directories-first --sort-by=modified"

else
	echo "Could not find tutils2 programs in $tutils2path"
	echo "Try the following, then re-open a terminal;"
	echo "cd"
	echo "git clone https://github.com/kivattt/tutils2"
	echo "cd tutils2"
	echo "./compile.bash"
fi

#---------------------------------------------------------#
# Cursed program aliases, remove these on a fresh install #
#---------------------------------------------------------#
alias krita="~/Downloads/krita-5.2.11-x86_64.AppImage"
alias idea="~/Downloads/idea/idea-IC-252.27397.103/bin/idea"
alias ideaultimate="~/Downloads/idea-IU-242.22855.74/bin/idea"
alias rider="/home/kivah/Downloads/rider/JetBrains\ Rider-2025.2.1/bin/rider"
alias clion="/home/kivah/Downloads/clion-2025.2.1/bin/clion"
alias discord="~/Downloads/discord/Discord/Discord"
alias re="~/Downloads/MultiMC/MultiMC"
alias blender="/home/kivah/Downloads/blender-4.2.1-linux-x64/blender"
alias rover="/home/kivah/Downloads/rustrover/RustRover-2025.2.1/bin/rustrover"
alias goland="/home/kivah/Downloads/goland/GoLand-2025.3.1.1/bin/goland"
alias renderdoc="/home/kivah/Downloads/renderdoc/renderdoc_1.40/bin/qrenderdoc"
alias godot="/home/kivah/Downloads/godot/Godot_v4.5.1-stable_linux.x86_64"
alias hytale="flatpak run com.hypixel.HytaleLauncher"

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:/home/kivah/Downloads/odin/odin-linux-amd64-nightly+2026-01-04"

alias lol="ssh ggr@172.16.195.61"

alias pycharm="/home/kivah/Downloads/pycharm/pycharm-2025.3.2/bin/pycharm"

alias puredata="flatpak run info.puredata.Pd"
alias maxmsp="wine \"/home/kivah/.steam/debian-installation/steamapps/compatdata/2691700104/pfx/drive_c/Program Files/Cycling '74/Max 9/Max.exe\""
