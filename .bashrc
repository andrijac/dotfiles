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
	if   [ "`hostname`" == "mmb01" ]; then echo 32 # blue
	elif [ "`hostname`" == "mini" ]; then echo 37 # white
	elif [ "`hostname`" == "fightclub.local" ]; then echo 33 # yellow
	else echo 36 # cyan
	fi
}

if [ "`hostname`" == "mmb" ] || [ "`hostname`" == "mmb2" ]; then
    # Disable setGitPrompt as the python version is too old
    function setGitPrompt() { echo; }
else
    . $HOME/bin/gitprompt.sh
fi

PROMPT_COMMAND='RET=$?'
PS1='\[\033[00;`retval`m\][`retval2 \!`] \[\033[00;37m\]`is_screen`\[\033[00;`hostcolor`m\]\h\[\033[00;37m\]:\[\033[01;34m\]\w\[\033[1;95m\]`setGitPrompt`\[\033[00m\]\$ '

############################################# Exports and aliases
alias u="uptime"
alias ssh="ssh -Y"
alias grep="grep -i"
alias mkdir="mkdir -p"
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias ls="ls --color=auto"
alias lpr="lpr -P Ochoa"
alias lpq="lpq -P Ochoa"
function lt() { ls -ltrsa "$@" | tail; }
function d() { dict "$@" | pager; }

export ARCH="`uname -m`"
export PATH=$PATH:bin:/usr/local/bin
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

require_machine mmb01 && 
    alias rmdir='trash' &&
    alias rm='trash' &&
    export PATH=$PATH:/srv/soft/vmd/bin:/srv/soft/gradle/1.0-milestone9/bin:$HOME/bin &&
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/usr/lib:$HOME/usr/lib_$ARCH:$HOME/usr/local/lib:$HOME/usr/local/lib_$ARCH:/usr/local/lib &&
    alias dropbox='python $HOME/.dropbox-dist/dropbox.py' &&
    source /srv/soft/environment-modules/3.2.10/Modules/3.2.10/init/bash &&
    alias op='xdg-open' &&
    export DBUS_SESSION_BUS_ADDRESS=

require_machine fightclub.local && 
    ARCH=`uname -m` export ARCH="$ARCH"_mach &&
    alias ls="ls -G" &&
    export PATH=/opt/bin:$PATH:/Applications/Scripts:/Applications/Xcode.app/Contents/Developer/usr/bin:$HOME/.gem/bin &&
	export GEM_HOME=$HOME/.gem

require_machine mini && 
    export NNTPSERVER="snews://news.eternal-september.org" &&
    alias tpy='transmission-remote-cli.py'

require_machine mmb &&
    export TERM=xterm

require_machine mmb2 &&
    export TERM=xterm

######################################### Always the last line
# Make 'source .bashrc' return 0
true
