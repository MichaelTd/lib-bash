#
# Perfect alias candidates are one liners or functions that take no arguments.
#shellcheck shell=bash

# Distro independent utils
# Package Search, Install, Remove
# Distro Update, Upgrade, Cleanup
if command -v apt-get &>/dev/null; then
    alias psearch='apt search' pinstall='sudo apt-get install' \
	  premove='sudo apt-get remove --purge'
    alias dupdate='sudo apt-get update' dupgrade='sudo apt-get dist-upgrade' \
	  dcleanup='sudo apt-get autoremove'
elif command -v zypper &>/dev/null; then
    alias psearch='zypper search' pinstall='sudo zypper install' \
	  premove='sudo zypper remove --clean-deps'
    alias dupdate='sudo zypper refresh' dupgrade='sudo zypper update' \
	  dcleanup='sudo zypper rm -u'
elif command -v yum &>/dev/null; then
    alias psearch='yum search' pinstall='sudo yum install' \
	  premove='sudo yum remove'
    alias dupdate='sudo yum check-update' dupgrade='sudo yum update' \
	  dcleanup='sudo yum autoremove'
elif command -v pacman &>/dev/null; then
    alias psearch='pacman -Ss' pinstall='sudo pacman -S' \
	  premove='sudo pacman -R'
    alias dupdate='sudo pacman -Sy' dupgrade='sudo pacman -Syu' \
	  dcleanup='sudo pacman -Rsn'
elif command -v emerge &>/dev/null; then
    alias psearch='emerge -s' pinstall='sudo emerge -av --autounmask' \
	  premove='sudo emerge -avC'
    alias dupdate='sudo emerge --sync' dupgrade='sudo emerge -avuND @world' \
	  dcleanup='sudo emerge --ask --depclean'
elif command -v pkg &>/dev/null; then
    alias psearch='pkg -o search' pinstall='sudo pkg install' \
	  premove='sudo pkg remove'
    alias dupdate='sudo pkg update' dupgrade='sudo pkg upgrade' \
	  dcleanup='sudo pkg autoremove'
fi

if command -v dircolors &>/dev/null; then
    # Color support
    # if [[ -r "${HOME}/.bashrc.d/00_colors.bash" ]]; then
    # 	  eval "$(dircolors -b "${HOME}/.bashrc.d/00_colors.bash")"
    # else
    #     eval "$(dircolors -b)"
    # fi
    alias ls='ls --color=auto --group-directories-first'
    alias la='ls --all --human-readable --color=auto --group-directories-first'
    alias ll='ls -l --all --human-readable --color=auto --group-directories-first'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto -in'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
else
    alias ls='ls --group-directories-first'
    alias la='ls --all --human-readable --group-directories-first'
    alias ll='ls -l --all --human-readable --group-directories-first'
    alias grep='grep -in'
fi

# Interactive & Verbose copy, move and remove commands
alias cp='cp -iv' mv='mv -iv' rm='rm -iv'

# Add --human-readable for various commands
alias du='du -hx' ncdu='ncdu -x' df='df -h'
alias duthis='du -hx --max-depth=1 | sort -hr|head'

# Midnight Commander Safe Terminal
# alias mcst='mc -a' # In case of malconfigured terminals
# Midnight Commander wrapper script
# alias mc='source /usr/share/mc/mc-wrapper.sh'

# Emacs alias
if type -P emacs &> /dev/null; then
    # EmaX No X11
    alias exnx='emacs -nw'
    # EmacsClient No X11
    alias ecnx='emacsclient -t'
    # EmacsClient Kill Daemon # Kill an emacs --daemon gracefully
    alias eckd='emacsclient --eval="(kill-emacs)"'
fi


# Various utils
alias cronobash='time bash -ic exit'
alias cronoemacs="time emacs --eval='(kill-emacs)'"
alias cronothis="time"
alias termgeom='echo "${COLUMNS}x${LINES}"'

# calendar
alias cal='cal -m' # First Day Monday Calendars

# cloc
#alias cloc='cloc --by-file-by-lang'

# fonts for st
#alias st='st -g 80x25 -f SourceCodePro-Regular'

# NET
# alias fixnet='ping -c 1 www.gentoo.org||sudo rc-service NetworkManager restart'
alias netis='ping -c 1 www.gentoo.org &> /dev/null;[[ $? == 0 ]] && echo "Net is UP!" || echo "Net is Down!"'

# Help wan-ip-howto
if type -P curl &> /dev/null; then
    alias wip4='curl ipv4.whatismyip.akamai.com;echo'
    alias wip6='curl ipv6.whatismyip.akamai.com;echo'
elif type -P wget &> /dev/null; then
    alias wip4='wget -qO - ipv4.whatismyip.akamai.com;echo'
    alias wip6='wget -qO - ipv6.whatismyip.akamai.com;echo'
fi

# Show attempts to establish a TCP connection (successful or not) to the IP 1.2.3.4
type -P tcpdump &> /dev/null && \
    alias lsconn='sudo tcpdump -nn tcp[tcpflags] == tcp-syn and dst host'

# Shutdown > halt & reboot & poweroff
# alias halt='sudo shutdown -h'
# alias reboot='sudo shutdown -r'

# ReMove Dead Links from current directory
alias rmdl='find -L . -name . -o -type d -prune -o -type l -exec rm -i {} +'

# Times table
# https://twitter.com/climagic/status/1187089764496891904
# Print a multiplication table. Great for those 3rd grader CLI users but also a great demo. :)
# alias multab='printf "%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n" $( echo {1..10}\*{1..10}\; | bc )'
alias multab='printf "$(echo %3d$_{1..10})\n" $(echo {1..10}\*{1..10}\;|bc)'
#shellcheck disable=SC2154
alias propaideia='for x in {1..9}; do for y in $(seq 1 $x); do printf "%dx%d=%2d\t" $y $x $((y*x));done;printf "\n";done'
# alias ttt='for x in {1..10}; do let tt="${x} * 10";for y in $(seq $x $x $tt);do printf "%4d" $y;done; printf "\n";done'

# https://twitter.com/liamosaur/status/506975850596536320
alias hugit='sudo $(history -p \!\!)' # fuckit='sudo $(history -p \!\!)' Political stup... err correctess canceled this one

# https://gist.github.com/seungwon0/802470
# curl -s http://whatthecommit.com | perl -p0e '($_)=m{<p>(.+?)</p>}s'
# curl -L -s http://whatthecommit.com/ | grep -A 1 "\"c" | tail -1 | sed 's/<p>//'
# curl -s http://whatthecommit.com/index.txt

if type -P git &> /dev/null; then
    # GIT
    alias gcl='git clone'
    alias gfc='git fetch'
    alias gst='git status'
    alias gdf='git diff'
    alias gaa='git add --all'
    alias gad='git add .'
    # alias gcm='git commit -m "$(curl -s whatthecommit.com/index.txt)"'
    alias gcm='git commit -m "$(date +%s)"'
    alias gps='git push'
    alias gal='gaa && gcm && gps'
    alias glp='git log -p'
    alias glg='git log --graph --pretty="%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
    # alias gco='git checkout'
    alias gpl='git pull --rebase'
    # alias grb='git rebase'
fi

# NETRIS
# https://git.sr.ht/~tslocum/netris?0.1.2
alias netris='ssh netris.rocketnine.space'

# Static, Good luck with high lvl lang implementations of lolcat.
# Recomended lolcat is: https://github.com/jaseg/lolcat
type -P lolcat &> /dev/null && \
    alias static='P=( " " █ ░ ▒ ▓ );while :;do printf "\e[$[RANDOM%LINES+1];$[RANDOM%COLUMNS+1]f${P[$RANDOM%5]}";done|lolcat'

# TermBin https://termbin.com/
# Usage: "command | termbin" or termbin <<<$(command)

alias termbindotcom='nc termbin.com 9999'

if type -P youtube-dl &> /dev/null; then
    alias ytdla='youtube-dl --extract-audio --audio-format mp3 --prefer-ffmpeg --ignore-errors --no-check-certificate'
    alias ytdlv='youtube-dl --format mp4 --prefer-ffmpeg --ignore-errors --no-check-certificate'
fi

# Bitcoin
# declare datadir="/mnt/el/.bitcoin" btcdir="${HOME}/git/scrap/bitcoin/src"
# #shellcheck disable=SC2139
# alias btccli="${btcdir}/bitcoin-cli -datadir=${datadir}" \
#       btcgui="${btcdir}/qt/bitcoin-qt -datadir=${datadir}" \
#       btchex="${btcdir}/bitcoin-tx -datadir=${datadir}" \
#       btcwlt="${btcdir}/bitcoin-wallet -datadir=${datadir}" \
#       btcdmn="${btcdir}/bitcoind -datadir=${datadir}"

# unset datadir btcdir

# alias btc_commands="btccli help"
# alias btc_info="btccli -getinfo"
# alias btc_winf="btcwlt -wallet=michaeltd info"

# declare monerodat="/mnt/data/.monero" monerodir="${HOME}/.local/monero-gui-v0.16.0.3"
# #shellcheck disable=SC2139
# alias monero_daemon="nice -n 9 ${monerodir}/monerod --data-dir ${monerodat} --check-updates disabled --max-concurrency 1" \
#       monero_gui="nice -n 9 ${monerodir}/monero-wallet-gui"
# unset monerodat monerodir

[[ -r ~/git/hoover/databases/database.db ]] && type -P sqlite3 &> /dev/null && \
    alias sql2data="sqlite3 \${HOME}/git/hoover/databases/database.db"
