source $HOME/.bash_functions


################################################# Color prompt
is_screen() {
	screen="`ps -a | grep SCREEN | grep -v grep`"
	if [ "$screen" != "" ]; then echo "S "; fi
}
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

hostcolor() {
	if   [ "`hostname`" == "valor-server" ]; then echo 32 # blue
	elif [ "`hostname`" == "mini" ]; then echo 37 # white
	elif [ "`hostname`" == "fightclub.local" ]; then echo 33 # yellow
	else echo 36 # cyan
	fi
}

PROMPT_COMMAND='RET=$?'
PS1='\[\033[00;`retval`m\][`retval2 \!`] \[\033[00;37m\]`is_screen`\[\033[00;`hostcolor`m\]\h\[\033[00;37m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

############################################# Exports and aliases
alias u="uptime"
alias ssh="ssh -Y"
alias grep="grep -i"
alias mkdir="mkdir -p"
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias ls="ls --color=auto"

export ARCH="`uname -m`"
export PATH=$PATH:bin/:/usr/local/bin
export MANPATH=$MANPATH:/usr/local/man/
export EDITOR="vim"
export PAGER="less"
export HISTCONTROL=ignoreboth
export TERM=xterm-256color

# Misc
shopt -s cdspell # spell check
shopt -s histappend # history append
set -o vi
umask 0002

############################################## Other software

# j https://github.com/rupa/j2/
export JPY=$HOME/bin/j.py
source $HOME/bin/j.sh

[[ -f /etc/bash_completion ]] && ! shopt -oq posix && . /etc/bash_completion

######################################### Machine-specific

# valor-server
require_machine valor-server && 
    alias rmdir='trash' &&
    alias rm='trash' &&
    export PATH=$PATH:$HOME/usr/bin:$HOME/usr/bin_$ARCH:$HOME/usr/local/bin:$HOME/usr/local/bin_$ARCH:/opt/vmd/bin:/srv/soft/gradle/1.0-milestone9/bin:$HOME/bin &&
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/usr/lib:$HOME/usr/lib_$ARCH:$HOME/usr/local/lib:$HOME/usr/local/lib_$ARCH:/usr/local/lib 

# fightclub
require_machine fightclub.local && 
    ARCH=`uname -m` export ARCH="$ARCH"_mach &&
    alias ls="ls -G" &&
    export PATH=$PATH:/Applications/Scripts:/Applications/Xcode.app/Contents/Developer/usr/bin/

# mini
require_machine mini && 
    export NNTPSERVER="snews://news.eternal-september.org" &&
    alias tpy='transmission-remote-cli.py'



######################################### Always the last line
# Make 'source .bashrc' return 0
true
