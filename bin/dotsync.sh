#!/usr/bin/env bash

# dotsync: sync my dotfiles using github


DIR="$HOME/.dotsync/dotfiles"
FILE_LIST=`sed "s_^_$HOME/.dotsync/dotfiles/_g" $DIR/list`

####################################### Helper functions
check_symlinks() {
    # Check for the availability of the function in_array
    [[ "`type -t in_array`" != "function" ]] && source $DIR/.bash_functions

    symlink_exceptions="list README.md"

    cd $HOME
    for i in $FILE_LIST; do
        # Do not symlink exceptions
        basename="`basename $i`"
        [[ `in_array "$basename" $symlink_exceptions` ]] && continue

        if [ -e "`basename $i`" ]; then
            if [ -h "`basename $i`" ]; then
                # Was a symlink, delete it because we'll update it
                rm "`basename $i`"
            else
                # Was a regular file! 
                echo `basename $i` already exists and is not a symlink! Ignored.
            fi
        fi
        ln -s $i
    done
    cd -
}

usage() {
    echo "Sends or Gets my dotfiles from the server"
    echo "Usage: dotsync [ -s | -g ] (Default: -s)"
}

####################################### Main functions

# dotsend: transfer dotfiles to the server
dotsend() {
    if [ ! -e "$DIR" ]; then
        echo "$DIR does not exist yet, please get the files first"
        return
    fi

    cd $DIR
    git add .[A-z]* *
    git commit -a
    git push &> /tmp/dotsync.log
    [[ $? -ne 0 ]] && cat /tmp/dotsync.log
    cd - &> /dev/null
}

# dotget: transfer dotfiles from server
dotget() {
    if [ -d "$DIR" ]; then
        cd $DIR
        git pull &> /tmp/dotsync.log
        [[ $? -ne 0 ]] && cat /tmp/dotsync.log
        cd -
    else
        # Need to initialize
        mkdir -p $HOME/.dotsync &> /dev/null
        cd $HOME/.dotsync
        git clone git@github.com:carlesfe/dotfiles.git
        cd -
    fi

    check_symlinks
}




############################################# Main

if [ "$1" == "" ] || [ "$1" == "-s" ]; then
    dotsend
elif [ "$1" == "-g" ]; then
    dotget
else
    usage
fi

exit 0
