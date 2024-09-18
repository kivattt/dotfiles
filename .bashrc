git_branch() {
	git branch --show-current 2> /dev/null
}

rainbowizepath=~/rainbowize
if test -x $rainbowizepath/rainbowize; then
	alias rainbowize="$rainbowizepath/rainbowize"
	export PS1="\[\033[1m\]$(~/rainbowize/rainbowize -fn $USER) \[\033[0m\]\w \[\033[0;35m\]\$(git_branch)\n\[\033[0;31m\033[0m\]\[\033[0;37m\]$\[\033[0m\] "
else
	export PS1="\[\033[0;32m\]\u \[\033[0m\]\w \[\033[0;35m\]\$(git_branch)\n\[\033[0;31m\033[0m\]\[\033[0;37m\]$\[\033[0m\] "
fi
export EDITOR=nvim

stty erase \^H

# Make Ctrl+s not freeze the terminal
[[ $- == *i* ]] && stty -ixon

clear
cd ~/main

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

	# Overriding the previous ls aliases since tutils2 ls doesn't work with the same arguments
	alias l="$tutils2path/ls -d --sort-by=modified"
	alias sl="$tutils2path/ls --all -d --sort-by=modified"
	alias cls="clear; $tutils2path/ls -d --sort-by=modified"
	alias csl="clear; $tutils2path/ls --all -d --sort-by=modified"

else
	echo "Could not find tutils2 programs in $tutils2path"
	echo "Try the following, then re-open a terminal;"
	echo "cd"
	echo "git clone https://github.com/kivattt/tutils2"
	echo "cd tutils2"
	echo "./compile.bash"
fi

#------------------------#
# Cursed program aliases #
#------------------------#
alias krita="~/Downloads/krita-5.2.3-x86_64.appimage"
alias idea="~/Downloads/idea-IC-242.20224.300/bin/idea"
#alias audacity="~/Downloads/audacity-linux-3.4.2-x64.AppImage"
alias discord="~/Downloads/discord/Discord/Discord"
alias re="~/Downloads/MultiMC/MultiMC"
alias blender="/home/kivah/Downloads/blender-4.2.1-linux-x64/blender"
