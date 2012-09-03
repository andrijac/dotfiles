while true; do
    xsetroot -name "`date +'%A %e, %k:%M'`"
    sleep 58
done &

xscreensaver -nosplash &
exec /usr/local/bin/dwm
