#!/usr/bin/env bash
#
# ~/bin/cronjobs.bash
# gather cronjobs for use with a familiar environment (/bin/bash)

declare -r usage="Usage: $(basename "${BASH_SOURCE[0]}") -(-a)larm | -(-b)ackup"

alarm() {
    echo -ne " -- ${FUNCNAME[0]} --\n"
    cvlc --random \
	 file:///mnt/data/Documents/Music/Stanley-Clarke/ \
	 file:///mnt/data/Documents/Music/Marcus-Miller/ \
	 file:///mnt/data/Documents/Music/Jaco-Pastorius/ \
	 file:///mnt/data/Documents/Music/Esperanza-Spalding/ \
	 file:///mnt/data/Documents/Music/Mark-King/Level-Best/
}

backup() {
    local bkpt="/mnt/el/Documents/BKP/LINUX/${USER}" bkpd="${HOME}" \
          xcldf="${HOME}/.bkp.exclude" rcpnt="tsouchlarakis@gmail.com"
    local outfl="${bkpt}/${USER}.$(date +%Y%m%d).$(date +%H%M%S).$(date +%s).tar.gz.pgp" \
          LS="$(type -P ls)"
    local nicm=( "$(type -P nice)" "-n" "9" ) \
	  tarc=( "$(type -P tar)" "-cz" "--exclude-from=${xcldf}" \
		 "--exclude-backups" "--one-file-system" "${bkpd}/." ) \
	  pgcm=( "$(type -P gpg2)" "--batch" "--yes" "--quiet" \
		 "--recipient" "${rcpnt}" "--trust-model" "always" "--output" "${outfl}" "--encrypt" )
    mkdir -p "${bkpt}"
    echo -ne " -- ${FUNCNAME[0]} --\n"
    if [[ -d "${bkpt}" ]]; then
	time ${nicm[@]} ${tarc[@]} | ${pgcm[@]}
	~/sbin/cleanup_bkps.bash --bkpdir "${bkpt}" --keep 2
    else
	echo "ERROR: Backup location: \"${bkpt}\" is not a directory" >&2
	exit 1
    fi
}

main() {
    if [[ -z "${1}" ]]; then
	echo "${usage}" >&2; exit 1
    else
	while [[ -n "${1}" ]]; do
	    case "${1}" in
		"-a"|"--alarm") alarm;;
		"-b"|"--backup") backup;;
		*) echo "${usage}" >&2; exit 1;;
            esac
            shift
	done
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi
