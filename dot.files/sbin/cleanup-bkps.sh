#!/usr/bin/env bash
#
# de-clutter backups

# Load explicitly for non interactive shells
source /home/paperjam/.bashrc.d/time.sh

printf "= $(basename ${BASH_SOURCE[0]}) =\n"

BKPD="/mnt/el/Documents/BKP/LINUX"

declare -a FLISTS=( "sys.tar.gz.asc" "usr.tar.gz.asc" "enc.tar.gz.asc" )

if [[ -d "${BKPD}" ]]; then
  cd "${BKPD}"
  for (( x = 0; x < ${#FLISTS[@]}; x++ )); do
    declare -a files=( $(ls -t *.${FLISTS[$x]}) ) # Sorting by mod time "-t", so no LC_LOCALE change required
    for (( y = 0; y < ${#files[@]}; y++ )); do
      if (( y > 6 )); then
        fn="${files[$y]}"
        pfn="${red}${fn}${reset}"
        dp="${fn:0:10}"
        etdt="$(epochtodatetime ${dp})"
        printf "${bold}${blue}will remove:${reset} %s, created: %s.\n" "${pfn}" "${underline}${green}${etdt}${reset}${end_underline}"
        printf "${bold}rm -v %s${reset} " "${pfn}"
        rm -v "${fn}"
      fi
    done
  done
else
  printf "${BKPD} not found\n" >&2
fi
