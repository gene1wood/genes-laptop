#!/bin/bash

if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias cgrep='grep --color=always'
    alias less='less -R'
fi

alias sgrep='grep --color=auto -R --exclude-dir=.svn --exclude-dir=.git'
alias e='/opt/sublime_text/sublime_text'
alias rpm-ql='dpkg --listfiles'
alias rpm-qi='dpkg --status'
alias rpm-qa='dpkg --list'
alias rpm-qf='dpkg --search'
alias rpm-qpi='dpkg --info'
alias yum-provides='apt-file search'
alias yum-search='apt-cache search'
alias yum-info='apt-cache show'
alias show-dns='nm-tool'
alias ping='ping -D'
