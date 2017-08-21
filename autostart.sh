#!/bin/bash
# X things
xrdb -merge ~/.Xresources 2> /dev/null

# import functions
source /etc/bash/bashrc.d/wallpaper-rotate.sh
# Add some wallpaper variety for your desktop
rotateBg &

# Monitor your box
#conky -DDDD -b -c ~/.conky.conf/.conkyrc.right.full >> ~/.conky.err/`date +%y%m%d`.conky.err.log 2>&1
#if [ -r "${HOME}"/bin/keepConkyAlive.sh ]; then
#    "${HOME}"/bin/keepConkyAlive.sh &
#fi
css="${HOME}/bin/conkyStart.sh"
if [[ -f "${css}" && -r "${css}" && -x "${css}" ]]; then
    "${css}" &
fi

tkrms="/usr/local/bin/TkRootMenu.sh"
# Start a Menu just in case
if [[ -f "${tkrms}" && -r "${tkrms}" && -x "${tkrms}" ]]; then
    "${tkrms}" &
fi

# quit screensaver if running
xscreensaver-command -exit
# Start screensaver in the background
xscreensaver -nosplash &
