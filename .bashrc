git_branch() {
	git branch --show-current 2> /dev/null
}

rainbowizepath=~/rainbowize
if test -x $rainbowizepath/rainbowize; then
	alias rainbowize="$rainbowizepath/rainbowize"
	export PS1="\[\033[1m\]$(~/rainbowize/rainbowize $USER) \[\033[0m\]\w \[\033[0;35m\]\$(git_branch)\n\[\033[0;31m\033[0m\]\[\033[0;37m\]$\[\033[0m\] "
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
alias fr="$EDITOR ~/.config/fen/fenrc.json"

alias p=cat
alias lowercase="tr [:upper:] [:lower:]"
alias uppercase="tr [:lower:] [:upper:]"

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

#-----------------------------------#
# My terminal file manager, fen     #
#-----------------------------------#
fenpath=~/fen
if test -x $fenpath/fen; then
	# Overriding the previous 'r' alias
	alias r="$fenpath/fen"
	alias fen="$fenpath/fen"
else
	echo "Could not find fen in $fenpath"
	echo "Try the following, then re-open a terminal;"
	echo "cd"
	echo "git clone https://github.com/kivattt/fen"
	echo "cd fen"
	echo "go build"
fi

#-----------------------------------#
# My coreutils replacements, tutils #
#-----------------------------------#
tutilspath=~/tutils/target/release
if test -d $tutilspath; then
	# If you like setting fire to your insides for fun, uncomment the line below
	#export PATH=$tutilspath:$PATH

	# These are a bunch of aliases because we don't want to mess with shell scripts that expect specific coreutils behaviour
	alias ls="$tutilspath/ls"
	alias pwd="$tutilspath/pwd"
	alias cat="$tutilspath/cat"
	alias p="$tutilspath/cat"
	alias hex="$tutilspath/hex"
	alias xxd="$tutilspath/xxd"
	alias ascii="$tutilspath/ascii"

	# Overriding the previous ls aliases since tutils ls doesn't work with the same arguments
	alias l="$tutilspath/ls"
	alias l="ls"
	alias sl="$tutilspath/ls --all"
	alias sl="ls --all"
	alias cls="clear; $tutilspath/ls"
	alias cls="clear; ls"
	alias csl="clear; $tutilspath/ls --all"
	alias csl="clear; ls --all"

else
	echo "Could not find tutils programs in $tutilspath"
	echo "Try the following, then re-open a terminal;"
	echo "cd"
	echo "git clone https://github.com/kivattt/tutils"
	echo "cd tutils"
	echo "cargo build --release"
fi

#------------------------#
# Cursed program aliases #
#------------------------#
alias krita="~/Downloads/krita-5.2.2-x86_64.appimage"
alias idea="~/Downloads/idea-IC-241.17011.79/bin/idea.sh"
alias audacity="~/Downloads/audacity-linux-3.4.2-x64.AppImage"
alias discord="~/Downloads/discord/Discord/Discord"
alias re="~/Downloads/MultiMC/MultiMC"
