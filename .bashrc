export PS1="$USER\n$ "
export EDITOR=nvim

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

alias v="$EDITOR"
alias b="$EDITOR ~/.bashrc"
alias vr="$EDITOR ~/.vimrc"

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

#alias fix='echo -e "\033c" ; stty sane; setterm -reset; reset; tput reset; clear'
#alias displayfix="export DISPLAY=:0"

#------------------------#
# Cursed program aliases #
#------------------------#
alias krita="~/Downloads/krita-5.1.5-x86_64.appimage"
alias idea="~/Downloads/intellij/idea-IC-232.9921.47/bin/idea.sh"
#alias medibang="wine64 ~/.wine/dosdevices/c:/\"Program Files\"/Medibang/\"MediBang Paint Pro\"/MediBangPaintPro.exe"

#------#
# PATH #
#------#
export PATH=$PATH:~/Downloads/nvim-linux64/bin

alias prs="ssh opc@129.146.190.97"
alias vifl="ssh server@109.198.23.126 -i ~/main/fuck"
alias k="ssh kivas@80.213.159.56 -p 80"
alias idea="~/Downloads/intellij/idea-IC-232.9921.47/bin/idea.sh"
