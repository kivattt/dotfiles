export PS1="$USER\n$ "
export EDITOR=nvim

if [[ "$TERM" == "xterm" ]]; then
	export TERM="xterm-256color"
fi

stty erase \^H

# Make Ctrl+s not freeze the terminal
[[ $- == *i* ]] && stty -ixon

#tmux
clear
cd ~/main

#----------------------#
# IP Address in prompt #
#----------------------#

#IP=`curl -4s ifconfig.me`
#if ! pidof obs > /dev/null 2> /dev/null
#then
#	IP=`curl -4 v4.ifconfig.co 2> /dev/null`
#	export PS1="$USER@$IP\n$ "
#else
#	export PS1="$USER@censored\n$ "
#fi

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
alias fen="/home/kivae/main/fen/fen"

