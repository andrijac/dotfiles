# Email loop: every 2 minutes
while true; do
    pass=`cat $HOME/.passwords/curl-new-gmail`
    newemails=`curl -u carlos.fenollosa:$pass --silent "https://mail.google.com/mail/feed/atom" | grep -oE "<fullcount>[[:digit:]]+</fullcount>" | grep -oE [[:digit:]] > /tmp/newemails`

    sleep 2m
done &

# Main loop: every 5 seconds
while true; do
    newemails=`cat /tmp/newemails`
    if [ $newemails -eq 0 ]; then
        mailsmsg="" 
    else
        mailsmsg="M: $newemails |"
    fi

    snd_on="`amixer get Master | grep 'Front Left:' | grep -oE '\[[[:alpha:]]+\]$'`"
    if [ "$snd_on" == "[on]" ]; then
        vol="V: `amixer get Master | grep 'Front Left:' | egrep -o '[[:digit:]]+%'` |"
    else
        vol="V: XX% |"
    fi

    date="`date +'%A %e, %k:%M'`"
    
    uptime="`uptime | awk -F "load average: " '{print $2}' | sed     's/,//g'` |"

    string="$mailsmsg $uptime $vol $date"
    xsetroot -name "$string"
    sleep 5
done &

dropbox start &
xset +fp ~/.fonts
parcellite -n -d &
xscreensaver -nosplash &
exec /usr/local/bin/dwm
