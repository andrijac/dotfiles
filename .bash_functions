# this file is meant to be sourced

# Avoid being sourced twice
[[ "`type -t in_array`" == "function" ]] && return 1 

# Check if a value exists in an array
#
# $1        Needle  
# $2        Haystack
# returns   0 if Needle is in Haystack, 1 else
# example   in_array apple "orange apple banana"
in_array() {
    haystack=$2

    if [ -z "$1" ]; then return 1; fi

    for i in ${haystack[@]}; do
        [[ "$1" == "$i" ]] && return 0
    done

    return 1
}


# Test which machine we run on
#
# $1        machine or list of machines which the script runs on .
#           use the actual hostname, please
# returns   0 if the script is runnable in this host, 1 else
# example   require_machine ""
require_machine() {
    return `in_array $HOSTNAME "$1"`
}


# Notify when a process finishes
# Please note that the finish time has an error of $interval seconds, fine for long processes 
# but not suitable for shorter ones.
# 
# $1        the PID
# $2        (optional) -b run in background and write a file instead of a message
finish() {
    interval=10

    if [[ $# -lt 1 ]]; then
        echo "Usage: finish PID [-b]ackground"
        return
    fi

    if [[ "$2" == "-b" ]]; then
        (while [[ $? -eq 0 ]]; do sleep $interval; ps -p $1 > /dev/null; done; date > /tmp/finish-$1.txt)&
        echo "Will write /tmp/finish-$1.txt when finished"
    else
        echo "Waiting for PID $1"
        while [[ $? -eq 0 ]]; do sleep $interval; ps -p $1 > /dev/null; done; date
    fi
}

true
