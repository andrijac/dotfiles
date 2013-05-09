source $HOME/.bash_functions


################################################# Color prompt
is_screen() {
	if [[ "$HOSTNAME" == "fightclub" ]]; then 
		screen="`ps -A | grep -i "screen$" | grep -v grep`"
	else
		screen="`ps axuf | grep "^$USER" | grep -i "screen$" | grep -v grep`"
	fi
	
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
	elif [ "`hostname`" == "fightclub" ]; then echo 33 # yellow
	else echo 36 # cyan
	fi
}

if [ "`hostname`" == "mmb" ] || [ "`hostname`" == "mmb2" ] || [ "`hostname`" == "dtransfer1" ] || [ "`hostname`" == "xecluster" ]; then
    # Disable setGitPrompt as the python version is too old
    function setGitPrompt() { echo; }
else
    . $HOME/bin/gitprompt.sh
fi

PROMPT_COMMAND='RET=$?; echo [$(date +"%H:%M:%S")] >> $HOME/.bash_history_enhanced'
PS1='\[\033[00;`retval`m\][`retval2 \!`] \[\033[01;30m\]\t \[\033[00;37m\]`is_screen`\[\033[00;`hostcolor`m\]\h\[\033[00;37m\]:\[\033[01;34m\]\w\[\033[1;95m\]`setGitPrompt`\[\033[00m\]\$ '

log_commands() {
    if [[ "$BASH_COMMAND" != "RET=\$?" ]] && [[ "$BASH_COMMAND" != 'j --add "$(pwd -P)"' ]] &&
        [[  "$BASH_COMMAND" != 'echo [$(date +"%H:%M:%S")] >> $HOME/.bash_history_enhanced' ]]; then
        d="`date +'%H:%M:%S'`"
        echo -n "[$d] $BASH_COMMAND " >> $HOME/.bash_history_enhanced
    fi
}

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
alias mlq="module load qsar-bundle"
alias pgrep="pgrep -l"
alias p="pager"
alias ks="ls"
alias tail="tail -n 40"
function lt() { ls -ltrsa "$@" | tail; }
function d() { dict "$@" | pager; }
function psgrep() { ps axuf | grep -v grep | grep "$@" -i --color=auto; }
function fname() { find . -iname "*$@*"; } 
# Fix 'cd folder' errors like 'c dfolder' which I do a lot
function c() { cmd="cd `echo $@ | cut -c 2-`"; echo $cmd; $cmd; }
function mcd() { mkdir $1 && cd $1; }


export ARCH="`uname -m`"
export PATH=$PATH:$HOME/bin:/usr/local/bin
export MANPATH=$MANPATH:/usr/local/man/
export EDITOR="vim"
export PAGER="less"
export HISTCONTROL=ignoreboth
export TERM=xterm-256color

# Misc
shopt -s cdspell # spell check
shopt -s histappend # history append
umask 002

############################################## Other software

# j https://github.com/rupa/j2/
export JPY=$HOME/bin/j.py
source $HOME/bin/j.sh

[[ -f /etc/bash_completion ]] && ! shopt -oq posix && . /etc/bash_completion

######################################### Machine-specific

require_machine mmb01 && 
    alias rmdir='trash' &&
    alias rm='trash' &&
    export PATH=/srv/soft/parallel/default/bin/:$PATH:/srv/soft/vmd/bin:/srv/soft/gradle/1.0-milestone9/bin &&
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/usr/lib:$HOME/usr/lib_$ARCH:$HOME/usr/local/lib:$HOME/usr/local/lib_$ARCH:/usr/local/lib &&
    alias dropbox='python $HOME/.dropbox-dist/dropbox.py' &&
    source /srv/soft/environment-modules/3.2.10/Modules/3.2.10/init/bash &&
    alias o='xdg-open' &&
    export DBUS_SESSION_BUS_ADDRESS= &&
    ssh-agent-manage &&
    export PDB=/srv/projects/valor/DATA/pdb

require_machine fightclub && 
    ARCH=`uname -m` export ARCH="$ARCH"_mach &&
    alias ls="ls -G" &&
    export PATH=/opt/bin:$PATH:/Applications/Scripts:/Applications/Xcode.app/Contents/Developer/usr/bin:$HOME/.gem/bin &&
	export GEM_HOME=$HOME/.gem &&
	function lt() { \ls -ltrsaG "$@" | tail; } &&
	alias o='open'

require_machine mini && 
    export NNTPSERVER="snews://news.eternal-september.org" &&
    alias tpy='transmission-remote-cli.py'

require_machine mmb &&
    export TERM=xterm

require_machine mmb2 &&
    export TERM=xterm

######################################### Always the last line
# Make 'source .bashrc' return 0
trap log_commands DEBUG
