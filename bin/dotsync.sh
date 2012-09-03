#!/usr/bin/env bash

# dotsync: sync my dotfiles using github


DIR="$HOME/.dotsync/dotfiles"

####################################### Helper functions
check_symlinks() {
    # Check for the availability of the function in_array
    [[ "`type -t in_array`" != "function" ]] && source $DIR/.bash_functions

    symlink_exceptions="list README.md"

    cd $HOME
    FILE_LIST=`sed "s_^_.dotsync/dotfiles/_g" $DIR/list`
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
                echo "Make it a symlink and run 'dotsync.sh -g' again"
            fi
        fi
        ln -s $i
    done
    cd - &> /dev/null
}

usage() {
    echo "Pushes or Updates my dotfiles from github"
    echo "Usage: dotsync [ -p | -u  | --servers ]"
    echo "Use '--servers' to propagate the current files to the servers"
}

####################################### Main functions

# dotpush: transfer dotfiles to the server
dotpush() {
    if [ ! -e "$DIR" ]; then
        echo "$DIR does not exist yet, please update the files first"
        return
    fi

    cd $DIR
    git add .[A-z]* *
    git commit -a
    git push &> /tmp/dotsync.log
    [[ $? -ne 0 ]] && cat /tmp/dotsync.log
    cd - &> /dev/null
}

# dotupdate: transfer dotfiles from server
dotupdate() {
    if [ -d "$DIR" ]; then
        cd $DIR
        git pull &> /tmp/dotsync.log
        [[ $? -ne 0 ]] && cat /tmp/dotsync.log
        cd - &> /dev/null
    else
        # Need to initialize
        mkdir -p $HOME/.dotsync &> /dev/null
        cd $HOME/.dotsync
        git clone git@github.com:carlesfe/dotfiles.git
        cd - &> /dev/null
    fi

    check_symlinks

    source $HOME/.bashrc
}

# Upload changes to the servers which don't have internet access
dotservers() {
    MACHINES="mn mt"

    for m in $MACHINES; do
        dir="`mktemp -d`"
        sshfs $m: $dir
        for i in `cat $HOME/.dotsync/dotfiles/list`; do cp -P $HOME/$i $dir; done
        cp -r $HOME/.dotsync $dir &> /dev/null
        fusermount -u $dir
        rmdir $dir
    done
}


############################################# Main

if [ "$1" == "-p" ]; then
    dotpush
elif [ "$1" == "-u" ]; then
    dotupdate
elif [ "$1" == "--servers" ]; then
    dotservers
else
    usage
fi

exit 0
