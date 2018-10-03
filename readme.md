# <p align="center">mick's dots</p>
<p align="center"><a href="http://www.tldp.org/LDP/abs/html/abs-guide.html"><img alt="bash-logo" src="assets/BASH_logo-transparent-bg-color.svg"></a></p>
<p align="center"><a href="http://unmaintained.tech/"><img alt="No Maintenance Intended" src="http://unmaintained.tech/badge.svg"></a> <a href="https://opensource.org/licenses/MIT"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg"></a></p>

  Possible use: "git clone https://github.com/MichaelTd/dots", go through the this repository and select what fits your needs so you can incorporate it in your working environment. My dots tend to be opinionated, so verbatim use of them is discouraged.

## [dot.files](dot.files)

- [Shell](dot.files/.bash_profile), [X setup](dot.files/.xinitrc), [bin](dot.files/bin/), [sbin (maintenance scripts)](dot.files/sbin/)

  * [.bashrc.d](dot.files/.bashrc.d) functions as a interactive shell initialization routine and it is customization of [Durag](http://dotshare.it/~Durag/)'s [Improved Terminal](http://dotshare.it/dots/1027/) at [http://dotshare.it/](http://dotshare.it/) with a prompt from [mathiasbynens](https://github.com/mathiasbynens/dotfiles)

  * [wallpaper-rotate.sh](dot.files/bin/wallpaper-rotate.sh)
  Script for rolling random images as wallpapers.
  <center><a href="dot.files/bin/wallpaper-rotate.sh"><img alt="Help screen" src="assets/wpr.png"></a></center>

  * [upgrade-distro.sh](dot.files/sbin/upgrade-distro.sh)
  Distro neutral upgrade script.


- Some WM's (in no particular order)

<center>

|wmaker|e16|openbox|awesome|compiz|mwm|
| ---- | ---- | ---- | ---- | ---- | ---- |
|<a href="dot.files/GNUstep/"><img width="50" alt="Window Maker" src="assets/wmaker.png"></a>|<a href="dot.files/.e16/"><img width="50" alt="e16" src="assets/e16.png"></a>|<a href="dot.files/.config/openbox/"><img width="50" alt="openbox" src="assets/openbox.png"></a>|<a href="dot.files/.config/awesome/"><img width="50" alt="awesome" src="assets/awesome.png"></a>|<a href="dot.files/.config/compiz/"><img width="50" alt="compiz" src="assets/compiz.png"></a>|<a href="dot.files/.mwmrc"><img width="50" alt="Motif WM" src="assets/mwm.png"></a>|
</center>
- Editors, [Utilities](dot.files/.tmux.conf).

   * If emacs is your "thing", check one of ...

     - https://github.com/technomancy/emacs-starter-kit
     - https://github.com/bbatsov/prelude
     - My setup consists of [a reasonable emacs config](https://github.com/purcell/emacs.d) and a special dashboard [splashscreen](https://github.com/notarock/.emacs.d/blob/master/splash.png)

  * If vim is what makes you "tick", check out [SpaceVim](https://github.com/SpaceVim/SpaceVim), a community maintained vim distribution.

#### [bootstrap.sh](bootstrap.sh)
How I migrate my .dots in new systems. Don's use this unless you are fully aware of the ramifications of the situation you put your self into.

## Reference
#### [GitHub ❤ ~/](https://dotfiles.github.io/)
Your unofficial guide to dotfiles on GitHub.

#### [Advanced Bash Scripting Guide](http://www.tldp.org/LDP/abs/html/abs-guide.html) ([PDF](http://www.tldp.org/LDP/abs/abs-guide.pdf))
The Bash all in one goto place.

#### [EbookFoundation free-programming-books - bash](https://github.com/EbookFoundation/free-programming-books/blob/master/free-programming-books.md#bash)
Free books relevant to bash (and much more).

#### [bash-hackers wiki](http://wiki.bash-hackers.org/)
See what other fellow bash'ers are up to.
