git_branch() {
	git branch --show-current 2> /dev/null
}
export PS1="\[\033[0;32m\]\u \[\033[0m\]\w \[\033[0;35m\]\$(git_branch)\n\[\033[0;31m\033[0m\]$ "
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

alias p=cat
alias lowercase="tr [:upper:] [:lower:]"
alias unique="sort -u"
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

#------------------------#
# Cursed program aliases #
#------------------------#
alias krita="~/Downloads/krita-5.2.2-x86_64.appimage"
alias idea="~/Downloads/idea-IC-233.14475.28/bin/idea.sh"
alias audacity="~/Downloads/audacity-linux-3.4.2-x64.AppImage"
alias discord="~/Downloads/discord/Discord/Discord"
alias re="~/Downloads/MultiMC/MultiMC"
alias fen="~/fen/fen" # github.com/kivattt/fen

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
