# ~/.bashrc.d/.stdlib/crypto.bash
#
# cryptographic functions
#shellcheck shell=bash

[[ ${SHELL} =~ bash$ ]] || return 1

gen_pass() {
    #shellcheck disable=SC2005
    tr -dc [:graph:] < /dev/urandom | \
	tr -d [=\|=][=\"=][=\'=][=\,=] | \
	head -c "${1:-64}"
    echo
}

gen_uuid() {
    # https://en.wikipedia.org/wiki/Universally_unique_identifier
    # https://github.com/niieani/bash-oo-framework/blob/master/lib/String/UUID.sh

    local N B C='89ab'

    for (( N = 1; N < 16; N++ )); do
	B="$(( RANDOM % 256 ))"
	case "${N}" in
	    6) printf '4%x' "$(( B % 16 ))";;
	    8) printf '%c%x' "${C:${RANDOM}%${#C}:1}" "$(( B % 16 ))";;
	    3|5|7|9) printf '%02x-' "${B}";;
	    *) printf '%02x' "${B}";;
	esac
    done
    printf '\n'
}

hash_stdin() {
    [[ "${#}" -ne "1" ]] && \
	echo "Usage: ${FUNCNAME[0]} cipher" && \
	return 1
    openssl dgst -"${1}"
}

transcode_stdin() {
    [[ "${#}" -ne "2" ]] && \
	echo "Usage: ${FUNCNAME[0]} e|d cipher" && \
	return 1
    openssl enc -"${2}" -base64 $([[ "${1}" == "d" ]] && echo "-d")
}

transcode_pgp() {
    case "${1}" in
	e|-e|--encrypt) shift; local fn="--encrypt" out="${1}.pgp";;
	d|-d|--decrypt)
	    shift
	    [[ "${1}" =~ \.pgp$ ]] || { echo "Need a .pgp file to decrypt!"; return 1; }
	    local fn="--decrypt" out="${1//\.pgp/}";;
	*) echo "Usage: ${FUNCNAME[0]} [e|d] [file|file.pgp]"; return 1;;
    esac
    gpg --default-recipient-self --output "${out}" "${fn}" "${1}"
}

rot_13(){

    [[ "${1}" != "-e" && "${1}" != "-d" ]] || [[ -z "${2}" ]] && \
	echo "Usage: ${FUNCNAME[0]} -e|-d argument(s)..." >&2 && return 1

    local -a _ABC=( "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" \
			"K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" \
			"U" "V" "W" "X" "Y" "Z" )
    local -a _abc=( "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" \
			"k" "l" "m" "n" "o" "p" "q" "r" "s" "t" \
			"u" "v" "w" "x" "y" "z" )
    local -a _NOP=( "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" \
			"X" "Y" "Z" "A" "B" "C" "D" "E" "F" "G" \
			"H" "I" "J" "K" "L" "M" )
    local -a _nop=( "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" \
			"x" "y" "z" "a" "b" "c" "d" "e" "f" "g" \
			"h" "i" "j" "k" "l" "m" )

    local _func="${1}"; shift
    
    while [[ -n "${1}" ]]; do
	local _word="${1}"
	local _out
	for (( i = 0; i <= ${#_word}; i++ )); do
	    for (( x = 0; x <= ${#_abc[*]}; x++ )); do
		case "${_func}" in
		    "-e")
			[[ "${_word:i:1}" == "${_ABC[x]}" ]] && \
			    _out+="${_NOP[x]}" && break
			[[ "${_word:i:1}" == "${_abc[x]}" ]] && \
			    _out+="${_nop[x]}" && break;;
		    "-d")
			[[ "${_word:i:1}" == "${_NOP[x]}" ]] && \
			    _out+="${_ABC[x]}" && break
			[[ "${_word:i:1}" == "${_nop[x]}" ]] && \
			    _out+="${_abc[x]}" && break;;
		esac
		#If char has not been found by now lets add it as is.
		(( x == ${#_abc[*]} )) && _out+="${_word:i:1}" 
	    done
	done
	shift
	_out+=" "
    done
    echo "${_out[*]}"
}

caesar_cipher() {
    # michaeltd 2019-11-30
    # https://en.wikipedia.org/wiki/Caesar_cipher
    # E n ( x ) = ( x + n ) mod 26.
    # D n ( x ) = ( x − n ) mod 26.

    local -a _ABC=( "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" \
			"K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" \
			"U" "V" "W" "X" "Y" "Z" )
    local -a _abc=( "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" \
			"k" "l" "m" "n" "o" "p" "q" "r" "s" "t" \
			"u" "v" "w" "x" "y" "z" )

    local _out

    if (( $# < 3 )) || \
	   [[ "$1" != "-e" && "$1" != "-d" ]] || \
	   (( $2 < 1 || $2 > 25 ))
    then
	echo "Usage: ${FUNCNAME[0]} -e|-d rotation (1-25) argument[(s)...]" >&2
	return 1
    fi

    _func="${1}"; shift
    _rotval="${1}"; shift

    while [[ -n "${1}" ]]; do
	for (( i = 0; i < ${#1}; i++ )); do
	    for (( x = 0; x < ${#_abc[*]}; x++ )); do
		case "${_func}" in
		    "-e")
			[[ "${1:i:1}" == "${_ABC[x]}" ]] && \
			    _out+="${_ABC[(( ( x + _rotval ) % 26 ))]}" && \
			    break
			[[ "${1:i:1}" == "${_abc[x]}" ]] && \
			    _out+="${_abc[(( ( x + _rotval ) % 26 ))]}" && \
			    break;;
		    "-d")
			[[ "${1:i:1}" == "${_ABC[x]}" ]] && \
			    _out+="${_ABC[(( ( x - _rotval ) % 26 ))]}" && \
			    break
			[[ "${1:i:1}" == "${_abc[x]}" ]] && \
			    _out+="${_abc[(( ( x - _rotval ) % 26 ))]}" && \
			    break;;
		esac
		# If char has not been found by now lets add it as is.
		(( x == ${#_abc[*]} - 1 )) && _out+="${1:i:1}"
	    done
	done
	_out+=" "
	shift
    done
    echo "${_out[*]}"
}

alpha2morse() {

    local -rA alpha_assoc=( \
        [A]='.-'    [B]='-...'  [C]='-.-.'  [D]='-..'    [E]='.' [F]='..-.' \
	[G]='--.'   [H]='....'  [I]='..'    [J]='.---'   [K]='-.-' \
	[L]='.-..'  [M]='--'    [N]='-.'    [O]='---'    [P]='.--.' \
	[Q]='--.-'  [R]='.-.'   [S]='...'   [T]='-'      [U]='..-' \
	[V]='...-'  [W]='.--'   [X]='-..-'  [Y]='-.--'   [Z]='--..' \
	[0]='-----' [1]='.----' [2]='..---' [3]='...--'  [4]='....-' \
	[5]='.....' [6]='-....' [7]='--...' [8]='----..' [9]='----.' )

    if [[ "${#}" -lt "1" ]]; then
	echo -ne "Usage: ${FUNCNAME[0]} arguments...\n ${FUNCNAME[0]} is an IMC transmitter. \n It'll transmit your messages to International Morse Code.\n" >&2
	return 1
    fi

    while [[ -n "${1}" ]]; do
	for (( i = 0; i < ${#1}; i++ )); do
	    local letter="${1:i:1}"
	    for (( y = 0; y < ${#alpha_assoc[${letter^^}]}; y++ )); do
		case "${alpha_assoc[${letter^^}]:y:1}" in
		    ".")
			echo -n "dot "
			play -q -n -c2 synth .05 2> /dev/null || sleep .05 ;;
		    "-")
			echo -n "dash "
			play -q -n -c2 synth .15 2> /dev/null || sleep .15 ;;
		esac
		sleep .05
	    done
	    echo
	    sleep .15
	done
	echo
	sleep .35
	shift
    done
}

rom2dec() {
    # https://rosettacode.org/wiki/Roman_numerals/Decode#UNIX_Shell
    local rnum="${1}"
    local n="0"
    local prev="0"
    local -A romans=( [M]="1000" [D]="500" [C]="100" [L]="50" [X]="10" [V]="5" [I]="1" )

    for (( i = ${#rnum}-1; i >= 0; i-- )); do
	a="${romans[${rnum:$i:1}]}"
     	[[ $a -lt $prev ]] && let n-=a || let n+=a
     	prev=$a
    done
       
    echo "$n"
}

dec2rom() {
    # https://rosettacode.org/wiki/Roman_numerals/Encode#UNIX_Shell
    local values=( 1000 900 500 400 100 90 50 40 10 9 5 4 1 )
    local roman=(
        [1000]=M [900]=CM [500]=D [400]=CD 
         [100]=C  [90]=XC  [50]=L  [40]=XL 
          [10]=X   [9]=IX   [5]=V   [4]=IV   
           [1]=I
    )
    local nvmber=""
    local num=$1
    for value in ${values[@]}; do
        while (( num >= value )); do
            nvmber+=${roman[value]}
            ((num -= value))
        done
    done
    echo $nvmber
 
}
 
rom2dec_alt(){
    local -ra ROM=( I V X L C D M ) DEC=( 1 5 10 50 100 500 1000 )
    while [[ -n "${*}" ]]; do
    	local NUM="${1}" RES=0 PRE=0
    	for (( i = ${#NUM}-1; i >= 0; i-- )); do
    	    for (( x = ${#ROM[*]} - 1 ; x >= 0  ; x-- )); do
    		if [[ "${NUM:$i:1}" == "${ROM[x]}" ]]; then
    		    local DIG="${DEC[x]}"
    		    break
    		fi
    	    done
    	    (( DIG < PRE )) && (( RES -= DIG )) || (( RES += DIG ))
    	    PRE="${DIG}"
    	done
    	echo "$NUM = $RES"
    	shift
    done
}

