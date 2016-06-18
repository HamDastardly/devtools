SRC_DIR=~/devtools/src
DOT_FILES=~/devtools/dotfiles

APT="sudo apt-get --quiet --assume-yes"
APT_INSTALL="${APT} install"
APT_UPDATE="${APT} update"
APT_REMOVE="${APT} remove"
APT_AUTOREMOVE="${APT} autoremove"
APT_CHECK="${APT} check"
APT_SANITIZE=${APT_UPDATE} && ${APT_AUTOREMOVE} && ${APT_CHECK}

CHECK_INSTALL="sudo checkinstall --maintainer=hamilton.little@gmail.com --default"

UPDATE_ALTS="sudo update-alternatives"

GIT_CLONE="git clone"
GIT_CONFIG="git config"

LINK="ln -s"
