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
/opt/redshift-1.8/src/redshift -l 41.388:2.114 -t 6500:5100 &
killpids="$killpids $!"

echo $killpids > /tmp/killpids

# Software that will NOT be killed when xdm closes
ps -A | \grep "screen$"
if [ $? -eq 1 ]; then screen -md; fi

# Misc configuration
setxkbmap -option ctrl:nocaps
xsetroot -solid black
xsetroot -cursor_name arrow

# Cool key modifiers
# To have two keys for backspace (i.e. the backspace and its leftmost) we need to
# -Hardware configure left tilde as escape, but put there the keycap for ` ~
# -Software configure the escape key to behave as tilde
#xmodmap -e "keycode 9 = dead_grave asciitilde"
# -Software configure the rightmost tilde key to behave as backspace
#xmodmap -e "keycode 49 = BackSpace"
# -Create a new escape key with keycode 255 so that xcape can bind to it
#xmodmap -e "keycode 255 = Escape"
# -ç using alt-c
xmodmap -e "keycode 54 = c C a a ccedilla Ccedilla"
# xcape configuration
# -Shifts, when pressed alone, generate parenthesis
# -CapsLock (Already remapped to Control), when pressed alone, generates escape
/opt/xcape/xcape -e 'Shift_L=parenleft;Shift_R=parenright;Control_L=Escape'

export PATH=$HOME/bin:$PATH
# Launch dwm
/opt/dwm-6.0/dwm

# When finished, kill the related X processes
kill `cat /tmp/killpids`
