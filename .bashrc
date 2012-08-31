# ~/.bashrc: executed by bash(1) for non-login shells.

source $HOME/.bash_functions

# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

retval() {
	if [ $RET -ne 0 ]; then echo 31; else echo 33; fi
}

retval2() {
	if [ $RET -ne 0 ]; then 
		# Align
		n_his=`echo $1 | wc -c`
		n_ret=`echo $RET | wc -c`
		spaces=""
		while [ $(( $n_his - $n_ret )) -gt 0 ]; do
			spaces="$spaces "
			n_ret=$(( $n_ret + 1 ))
		done

		echo "$spaces$RET"; 
	else
		echo $1
	fi
}

PROMPT_COMMAND='RET=$?'

if [ "$color_prompt" = yes ]; then
    #PS1='\[\033[00;`retval $?`m\][\!`retval2 $?`] \[\033[00;32m\]\h\[\033[00m\]:\[\033[00;34m\]\w\[\033[00m\]\$ '
    PS1='\[\033[00;`retval`m\][`retval2 \!`] \[\033[00;32m\]\h\[\033[00m\]:\[\033[00;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep -i --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
[[ `require_machine valor-server` ]] && alias rmdir='trash'
[[ `require_machine valor-server` ]] && alias rm='trash'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Bash does typo checking!
shopt -s cdspell

umask 0002

# usr/ settings
export ARCH=`uname -m`
export PATH=$PATH:$HOME/usr/bin:$HOME/usr/bin_$ARCH:$HOME/usr/local/bin:$HOME/usr/local/bin_$ARCH:/opt/vmd/bin:/usr/local/bin:/srv/soft/gradle/1.0-milestone9/bin:$HOME/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/usr/lib:$HOME/usr/lib_$ARCH:$HOME/usr/local/lib:$HOME/usr/local/lib_$ARCH:/usr/local/lib

export EDITOR="vim"

set -o vi # use vi keybindings

# j https://github.com/rupa/j2/
export JPY=$HOME/bin/j.py
. $HOME/bin/j.sh

