#!/bin/bash

if [ -f $HOME/.Xdefaults ]; then xrdb -merge $HOME/.Xdefaults; fi

# Processes that we will kill when we close X
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
    $HOME/bin/refresh-statusbar.sh
    sleep 5
done &
killpids="$killpids $!"

# Other software which will be killed when xdm closes
numlockx on
$HOME/.dropbox-dist/dropboxd &
killpids="$killpids $!"
xset +fp ~/.fonts
parcellite -n -d &
killpids="$killpids $!"
xscreensaver -nosplash &
killpids="$killpids $!"

echo $killpids > /tmp/killpids

# Software that will NOT be killed when xdm closes
ps -A | \grep "screen$"
if [ $? -eq 1 ]; then screen -md; fi

# Misc configuration
setxkbmap -option ctrl:nocaps
xsetroot -solid black
xsetroot -cursor_name arrow

export PATH=$HOME/bin:$PATH
# Launch dwm
/opt/dwm-6.0/dwm

# When finished, kill the related X processes
kill `cat /tmp/killpids`
