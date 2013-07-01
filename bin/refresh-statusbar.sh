#!/usr/bin/env bash

newemails=`cat /tmp/newemails | sed 's/[^0-9]//g'`
if [ "$newemails" != "" ]; then
    if [ $newemails -eq 0 ]; then
        mailsmsg="" 
    else
        mailsmsg="M: $newemails |"
    fi
fi



snd_on=`amixer get Master | grep 'Front Left:' | grep -oE '\[[[:alpha:]]+\]$' | grep -oE '[[:alpha:]]+'`
vol=`amixer get Master | grep 'Front Left:' | egrep -o '[[:digit:]]+%' | egrep -o '[[:digit:]]+'`
# Weird poltergeist, comparing "$snd_on" == "on" produces an error
if [ "$snd_on" != "off" ]; then
    if [ $vol -eq 0 ]; then vol="....."
    elif [ $vol -gt 0 ] && [ $vol -lt 10 ]; then vol="o...."
    elif [ $vol -ge 10 ] && [ $vol -lt 20 ]; then vol="O...."
    elif [ $vol -ge 20 ] && [ $vol -lt 30 ]; then vol="Oo..."
    elif [ $vol -ge 30 ] && [ $vol -lt 40 ]; then vol="OO..."
    elif [ $vol -ge 40 ] && [ $vol -lt 50 ]; then vol="OOo.."
    elif [ $vol -ge 50 ] && [ $vol -lt 60 ]; then vol="OOO.."
    elif [ $vol -ge 60 ] && [ $vol -lt 70 ]; then vol="OOOo."
    elif [ $vol -ge 70 ] && [ $vol -lt 80 ]; then vol="OOOO."
    elif [ $vol -ge 80 ] && [ $vol -lt 90 ]; then vol="OOOOo"
    elif [ $vol -ge 90 ]; then vol="OOOOO"
    fi
else
    if [ $vol -eq 0 ]; then vol="....."
    elif [ $vol -gt 0 ] && [ $vol -lt 10 ]; then vol="m...."
    elif [ $vol -ge 10 ] && [ $vol -lt 20 ]; then vol="M...."
    elif [ $vol -ge 20 ] && [ $vol -lt 30 ]; then vol="Mm..."
    elif [ $vol -ge 30 ] && [ $vol -lt 40 ]; then vol="MM..."
    elif [ $vol -ge 40 ] && [ $vol -lt 50 ]; then vol="MMm.."
    elif [ $vol -ge 50 ] && [ $vol -lt 60 ]; then vol="MMM.."
    elif [ $vol -ge 60 ] && [ $vol -lt 70 ]; then vol="MMMm."
    elif [ $vol -ge 70 ] && [ $vol -lt 80 ]; then vol="MMMM."
    elif [ $vol -ge 80 ] && [ $vol -lt 90 ]; then vol="MMMMm"
    elif [ $vol -ge 90 ]; then vol="MMMMM"
    fi
fi

vol="V: $vol |"

date="`date +'%A %e, %k:%M'`"

uptime="`uptime | awk -F "load average: " '{print $2}' | sed     's/,//g'` |"

string="$mailsmsg $uptime $vol $date"
xsetroot -name "$string"
