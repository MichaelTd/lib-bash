#!/usr/bin/env -S bash --norc --noprofile
#shellcheck shell=bash disable=SC1008,SC2096
#
# Simple password cli.
# Consistent use of ${PAGER} ensures there's no password "bleed" from terminals with persistant history configured.
# Also ~/.bash_history gets purged for ${sbn} instances in each function call.

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\t\n'

#link free (S)cript: (D)ir(N)ame, (B)ase(N)ame.
#shellcheck disable=SC2155,SC2034
readonly sdn="$(dirname "$(realpath "${BASH_SOURCE[0]}")")" \
	 sbn="$(basename "$(realpath "${BASH_SOURCE[0]}")")"

passcli() {
    local -ra pgpc=( "gpg" "--quiet" "--batch" "--yes" "--default-recipient-self" "--output" ) \
	  shrc=( "shred" "--zero" "--remove" )
    local -r pass_file="${HOME}/.passfile"
    local -r pass_pgp="${pass_file}.pgp" pass_bkp="${pass_file}.bkp"
    local -r pass_header="
    '########:::::'###:::::'######:::'######:::'######::'##:::::::'####:
     ##.... ##:::'## ##:::'##... ##:'##... ##:'##... ##: ##:::::::. ##::
     ##:::: ##::'##:. ##:: ##:::..:: ##:::..:: ##:::..:: ##:::::::: ##::
     ########::'##:::. ##:. ######::. ######:: ##::::::: ##:::::::: ##::
     ##.....::: #########::..... ##::..... ##: ##::::::: ##:::::::: ##::
     ##:::::::: ##.... ##:'##::: ##:'##::: ##: ##::: ##: ##:::::::: ##::
     ##:::::::: ##:::: ##:. ######::. ######::. ######:: ########:'####:
    ..:::::::::..:::::..:::......::::......::::......:::........::....::
"
    show_header() {
	clear
	if type -P lolcat &> /dev/null; then
	    echo "${pass_header}"|lolcat
	else
	    echo "${pass_header}"
	fi
    }

    usage() {
	echo -ne "\n Usage: ${sbn} add 'domain,mail,name,pass'|rem keywd|list [keywd]|empty for all\n\n" >&2
    }

    purge_hist() {
	sed -i "/${sbn}/d" "${HOME}/.bash_history"
    }
    
    encrypt() {
	"${pgpc[@]}" "${pass_pgp}" "--encrypt" "${pass_file}"
	"${shrc[@]}" {"${pass_file}","${pass_bkp}"} 2> /dev/null
    }

    decrypt() {
	if [[ -e "${pass_pgp}" ]]; then
	    "${pgpc[@]}" "${pass_file}" "--decrypt" "${pass_pgp}"
	else
	    echo 'domain,email,username,password' > "${pass_file}"
	fi
    }

    list() {
	if [[ -n "${*}" ]]; then
	    grep -h "${1}" "${pass_file}" | column -t -s "," | "${PAGER}"
	else
	    column -t -s "," "${pass_file}" | "${PAGER}"
	fi
    }

    rem() {
	list "${1}"
	if [[ "$(read -rp "Delete above entr(y/ies) from password file? [y/N] " r;echo "${r:-N}")" == [Yy]* ]]; then
            cp -f "${pass_file}" "${pass_bkp}"
            grep -hv "${1}" "${pass_bkp}" > "${pass_file}"
	fi
    }

    add() {
	echo "${*}" >> "${pass_file}"
	list
    }

    case "${*}" in
	add*|rem*|list*)
	    show_header
	    decrypt
	    "${@}"
	    encrypt
	    purge_hist;;
	*)
	    show_header
	    usage
	    return 1;;
    esac
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && "${sbn%.*}" "${@}"
