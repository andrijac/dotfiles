#!/usr/bin/env bash

# dotsync: sync my dotfiles using github


DIR="$HOME/.dotsync/dotfiles"
FILE_LIST=`sed "s_^_$HOME/.dotsync/dotfiles/_g" $HOME/.dotsync/dotfiles/list`

####################################### Helper functions
check_symlinks() {
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
                echo `basename $i` already exists!
            fi
        fi
        ln -s $i
        echo $i
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
    git push
    cd -
}

# dotget: transfer dotfiles from server
dotget() {
    if [ -d "$DIR" ]; then
        cd $DIR
        git pull
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
