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

