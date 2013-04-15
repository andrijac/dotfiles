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

# Check for ssh-agent
ssh-agent-manage() {
    pid=`\pgrep ssh-agent`
    if [[ -z $pid ]]; then
        # Not running
        eval $(ssh-agent)
        ssh-add
    else
        # Running, re-set variables
        export SSH_AGENT_PID=$pid
        id=$(( $pid -1 ))
        export SSH_AUTH_SOCK="`find /tmp/ssh* -iname \"agent.*\"`"
    fi
}

# Mini wizard for lpr options
#
# $1 the file to print
lpr-wizard() {
    [[ ! -f "$1" ]] && echo "Usage: lpr-wizard file" && return 1

    echo -n "Printer? (Ochoa) "
    read p

    # Let's trust the user on this one
    [[ "$p" == "" ]] && p="Ochoa"

    echo -n "Two sided? (Y/n) "
    read ts
    # default is 'y' so 'n' must be explicit. Other answers yield 'y'
    [[ "$ts" == "N" ]] && ts=n
    [[ "$ts" != "n" ]] && ts=y

    echo -n "Two pages per side? (y/N) "
    read tp
    # default is 'n' so 'y' must be explicit. Other answers yield 'n'
    [[ "$tp" == "Y" ]] && tp=y
    [[ "$tp" != "y" ]] && tp=n

    command="lpr -P Ochoa"
    [[ "$ts" == "y" ]] && [[ "$tp" == "n" ]] && command="lpr -P $p $1"
    [[ "$ts" == "y" ]] && [[ "$tp" == "y" ]] && command="lpr -P $p -o number-up=2 -o sides=two-sided-short-edge"
    [[ "$ts" == "n" ]] && [[ "$tp" == "n" ]] && command="lpr -P $p $1 -o sides=one-sided"
    [[ "$ts" == "n" ]] && [[ "$tp" == "y" ]] && command="lpr -P $p $1 -o sides=one-sided -o number-up=2"

    $command
}


# Extract some pages from a pdf file
#
# $1 the first page
# $2 the last page to extract (included)
# $3 the input pdf
# $4 the output pdf
function pdfpages() {
    [[ -z $1 ]] && echo "Usage: pdfpages firstpage lastpage input.pdf output.pdf" && return
    gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=$1 -dLastPage=$2 -sOutputFile=$4 $3 &> /dev/null
}
