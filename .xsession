#!/usr/bin/env bash

source $HOME/.bashrc
[[ -f $HOME/.Xdefaults ]] && xrdb -merge $HOME/.Xdefaults

killpids=""

# Email loop: every 2 minutes
while true; do
    pass=`cat $HOME/.passwords/curl-new-gmail`
    newemails=`curl -u carlos.fenollosa:$pass --silent "https://mail.google.com/mail/feed/atom" | grep -oE "<fullcount>[[:digit:]]+</fullcount>" | grep -oE [[:digit:]] > /tmp/newemails`

    sleep 2m
done &
killpids="$killpids $!"

# Main loop: every 5 seconds
while true; do
    newemails=`cat /tmp/newemails`
    if [ "$newemails" != "" ]; then
        if [ $newemails -eq 0 ]; then
            mailsmsg="" 
        else
            mailsmsg="M: $newemails |"
        fi
    fi



    snd_on=`amixer get Master | grep 'Front Left:' | grep -oE '\[[[:alpha:]]+\]$' | grep -oE '[[:alpha:]]+'`
    vol=`amixer get Master | grep 'Front Left:' | egrep -o '[[:digit:]]+%' | egrep -o '[[:digit:]]+'`
    echo vol: $vol
    # Weird poltergeist, comparing "$snd_on" == "on" produces an error
    if [ "$snd_on" != "off" ]; then
        if [ $vol -eq 0 ]; then vol="....."
        elif [ $vol -gt 0 ] && [ $vol -lt 10 ]; then vol="o...."
        elif [ $vol -gt 10 ] && [ $vol -lt 20 ]; then vol="O...."
        elif [ $vol -gt 20 ] && [ $vol -lt 30 ]; then vol="Oo..."
        elif [ $vol -gt 30 ] && [ $vol -lt 40 ]; then vol="OO..."
        elif [ $vol -gt 40 ] && [ $vol -lt 50 ]; then vol="OOo.."
        elif [ $vol -gt 50 ] && [ $vol -lt 60 ]; then vol="OOO.."
        elif [ $vol -gt 60 ] && [ $vol -lt 70 ]; then vol="OOOo."
        elif [ $vol -gt 70 ] && [ $vol -lt 80 ]; then vol="OOOO."
        elif [ $vol -gt 80 ] && [ $vol -lt 90 ]; then vol="OOOOo"
        elif [ $vol -gt 90 ]; then vol="OOOOO"
        fi
    else
        if [ $vol -eq 0 ]; then vol="....."
        elif [ $vol -gt 0 ] && [ $vol -lt 10 ]; then vol="m...."
        elif [ $vol -gt 10 ] && [ $vol -lt 20 ]; then vol="M...."
        elif [ $vol -gt 20 ] && [ $vol -lt 30 ]; then vol="Mm..."
        elif [ $vol -gt 30 ] && [ $vol -lt 40 ]; then vol="MM..."
        elif [ $vol -gt 40 ] && [ $vol -lt 50 ]; then vol="MMm.."
        elif [ $vol -gt 50 ] && [ $vol -lt 60 ]; then vol="MMM.."
        elif [ $vol -gt 60 ] && [ $vol -lt 70 ]; then vol="MMMm."
        elif [ $vol -gt 70 ] && [ $vol -lt 80 ]; then vol="MMMM."
        elif [ $vol -gt 80 ] && [ $vol -lt 90 ]; then vol="MMMMm"
        elif [ $vol -gt 90 ]; then vol="MMMMM"
        else echo "#$vol#"
        fi
    fi

    vol="V: $vol |"

    date="`date +'%A %e, %k:%M'`"
    
    uptime="`uptime | awk -F "load average: " '{print $2}' | sed     's/,//g'` |"

    string="$mailsmsg $uptime $vol $date"
    xsetroot -name "$string"
    sleep 5
done &
killpids="$killpids $!"

numlockx on
dropbox start &
killpids="$killpids $!"
xset +fp ~/.fonts
parcellite -n -d &
killpids="$killpids $!"
xscreensaver -nosplash &
killpids="$killpids $!"

echo $killpids > /tmp/killpids
/usr/local/bin/dwm
kill `cat /tmp/killpids`
