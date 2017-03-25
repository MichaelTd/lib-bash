#!/bin/bash

# USE AT YOUR OWN RISK! IN CASE OF FIRE OR CATASTROPHIC FAILURE,
# CALL 911 AND OTHER APROPRIATE AUTHORITIES!
#
# tsouchlarakis@gmail.com 2016.10.05
#
# GNU/GPL https://www.gnu.org/licenses/gpl.html
#

# Simple script to go through a directory of background images
# as wallpapers in a timely fashion
function rotateBg {

  USAGE=$(cat <<EOF

Quick and dirty script to rotate backgrounds in wm's with out such options (ie NOT kde, gnome or xfce4)

  Usage: source wallpaper.rotate.sh && rbgHelperAddDir /home/user/pictures && rotateWP

EOF
  )

  if [ -x `which feh` ]; then              # Find a setter or die trying
    BGSETTER="feh --bg-scale"
  elif [ -x `which wmsetbg` ]; then
    BGSETTER="wmsetbg"
  elif [ -x `which fvwm-root` ]; then
    BGSETTER="fvwm-root"
  elif [ -x `which fbsetbg` ]; then
    BGSETTER="fbsetbg"
  elif [ -x `which bsetbg` ]; then
    BGSETTER="bsetbg"
  elif [ -x `which hsetroot` ]; then
    BGSETTER="hsetroot -fill"
  elif [ -x `which xsetroot` ]; then
    BGSETTER="xsetroot -bitmap"
  else
    echo "${USAGE}"
    return 1
  fi

  DEFAULT_WPDIR="${HOME}/.wallpapers"      # Assign a default wp dir
  DEFAULT_WAIT="60s"                       # and a default wait interval

  if [ -r "${HOME}"/.wallpaper.rotate.rc ]; then   # If there is a readable settings file, read it
    source "${HOME}"/.wallpaper.rotate.rc
  fi

  WPD=${2-${DEFAULT_WPDIR}}                # take second argument as a wp dir or assign a default.
  WPL=( `ls ${WPD}` )                      # fill array with values
  WPN=${#WPL[*]}                           # get array upper bound

  while true ; do
    let "RN = $RANDOM % $WPN"              # limit a random num to upper array bounds
    WP="${WPD}/${WPL[$RN]}"                # Get path and name of image
    if [ -d "$WP" ]; then                  # Check if item is a dir
      sleep ${1-${DEFAULT_WAIT}}           # Try again later
    else
      ${BGSETTER} "$WP"                    # set wallpaper, wait
      sleep ${1-${DEFAULT_WAIT}}
    fi
  done
}

# Helper function to populate "~/.wallpapers" directory with links to image files.
#
# First time use of rotateBg, you'll need to run this function first
# with an image file directory as parameter to initialize "~/.wallpapers".
# (create "~/.wallpapers" and populate it)
#
# Call this function with the dir you'd like to add its images as links in "~/.wallpapers"
# for use with "rotateBg" function. eg: "rbgHelperAddDir /home/user/pictures"
function rbgHelperAddDir {
  DEFAULT_WPDIR="${HOME}/.wallpapers"            # Assign a default wp dir
  if [ -r ${HOME}/.wallpaper.rotate.rc ]; then   # If there is a readable settings file, read it
    source ${HOME}/.wallpaper.rotate.rc
  fi
  mkdir "${DEFAULT_WPDIR}" 2> /dev/null    # What errors?
  for i in `ls "${1}"`; do
    FE=${i:(-4)}                           # Get file extention ${str:(-4)} and lowercase it ${FE,,}
    if [[ ${FE,,} == ".jpg" ]] || [[ ${FE,,} == ".png" ]] || [[ ${FE,,} == ".gif" ]] || [[ ${FE,,} == ".bmp" ]]; then
      ln -sf "${1}"/"${i}" "${DEFAULT_WPDIR}"/"${i}"
    fi
  done
}

# Helper function to remove links of images from a given directory in "~/.wallpapers"
#
# Means to remove a directory (previously added with rbgHelperAddDir /home/user/pictures)
# from use with "rotateBg"
#
# Use this function with the unwanted dir as its sole parameter
# eg: "rbgHelperRemoveDir /home/user/pictures"
# It is meant to be called interactively and not from within scripts
function rbgHelperRemoveDir {
  DEFAULT_WPDIR="${HOME}/.wallpapers"           # Assign a default wp dir
  if [ -r ${HOME}/.wallpaper.rotate.rc ]; then  # If there is a readable settings file, read it
    source ${HOME}/.wallpaper.rotate.rc
  fi
  for i in `ls "${1}"`; do
    FE=${i:(-4)}                           # Get file extention ${str:(-4)} and lowercase it ${FE,,}
    if [[ ${FE,,} == ".jpg" ]] || [[ ${FE,,} == ".png" ]] || [[ ${FE,,} == ".gif" ]] || [[ ${FE,,} == ".bmp" ]]; then
      rm -i "${DEFAULT_WPDIR}"/"${i}"      # rm --interactive just to play it safe, this func
    fi
  done
}
