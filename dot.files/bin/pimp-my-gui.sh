#!/usr/bin/env bash
#
# ~/bin/pimp-my-gui.sh
# Spice for the desktop

# Run things in the background with custom niceness and cli switches in a mutex kind of way
# Usage : custom_run niceness executable command line arguments
function custom_run {
  bin=$(which "${2}")
  pid=$(pidof "${2}")
  if [[ -z "${pid}" && -x "${bin}" ]]; then
    nice -n "${@}" &
  fi
}

# Start an X11 compositor
# custom_run 19 compton

# XScreenSaver
custom_run 9 xscreensaver -no-splash

# A calendar app
# custom_run 9 orage

# Networking Python gui
# nice -n 9 wicd-gtk -t &

# Per distro setup.
source /etc/os-release
if [[ "${ID}" == "gentoo" ]]; then
  sleep 1m && custom_run 9 conky -qdc ~/.conky/FreeClox/config/.conkyrc &
elif [[ "${ID}" == "devuan" ]]; then
  custom_run 9 xfce4-terminal --disable-server
  custom_run 9 conky -qd
else
  custom_run 9 xterm
  custom_run 9 conky -qd
fi

# Start a Menu
# nice -n 9 ${HOME}/bin/tkrm.sh &

# Add some wallpaper variety for your desktop
${HOME}/bin/wallpaper-rotate.sh &

# Run emacs
custom_run 0 emacs --daemon

# Run mpd
custom_run 0 mpd
