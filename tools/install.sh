#!/bin/bash
main() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  echo ""

  # LINUX or OSX Sublime path:
  SUBLIME_OSX=~/Library/Application\ Support/Sublime\ Text\ 3/Packages
  SUBLIME_LINUX=~/.config/sublime-text-3/Packages

  # Detect OS:
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    SUBLIME=$SUBLIME_LINUX
    printf "${BOLD}Linux detected${NORMAL}\n\n"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    SUBLIME=$SUBLIME_OSX
    printf "${BOLD}OSX detected.${NORMAL}\n"
  elif [[ "$OSTYPE" == "cygwin" ]]; then
    echo "${RED}To install on Windows, refer to the README.${NORMAL}\n"
    exit 1
  else
    echo "${RED}It wasn't possible to detect your operating system. Please refer to manual installation.${NORMAL}\n"
    exit 1
  fi

  # Set installation folder
  INSTALL=$SUBLIME/mvn-pcs-sublime

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  if [ ! -d "$SUBLIME" ]; then
    printf "${RED}Couldn't find ${SUBLIME}\n"
    printf "Make sure Sublime Text 3 is installed.${NORMAL}\n\n"
    printf "If it's installed, manually look for the 'Packages' folder and clone the repository there by running:\n\n"
    printf "git clone https://github.com/rogerioyuuki/mvn-pcs-sublime.git --branch master --single-branch --depth 1\n\n"
    exit
  fi

  if [ -d "$INSTALL" ]; then
    printf "${YELLOW}MVN PCS Sublime is already installed.${NORMAL}\n"
    printf "You'll need to remove ${INSTALL} if you want to re-install.\n\n"
    exit
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  printf "${BLUE}Cloning repository...${NORMAL}\n"
  hash git >/dev/null 2>&1 || {
    echo "${RED}Error: git is not installed.${NORMAL}\n"
    exit 1
  }
  env git clone https://github.com/rogerioyuuki/mvn-pcs-sublime.git "$INSTALL" --branch master --single-branch --depth 1 || {
    printf "${RED}Error: git clone of mvn-pcs-sublime repo failed.${NORMAL}\n"
    exit 1
  }

  # The Windows (MSYS) Git is not compatible with normal use on cygwin
  if [ "$OSTYPE" = cygwin ]; then
    if git --version | grep msysgit > /dev/null; then
      echo "Error: Windows/MSYS Git is not supported on Cygwin"
      echo "Error: Make sure the Cygwin git package is installed and is first on the path"
      exit 1
    fi
  fi

  printf "${GREEN}"
  echo "    ____________________________ "
  echo "  /|............................| "
  echo " | |:     Syntax Definition    :| "
  echo " | |:         \"MVN PCS\"        :| "
  echo " | |:     ,-.   _____   ,-.    :| "
  echo " | |:    ( \`)) [_____] ( \`))   :| "
  echo " |v|:     \`-\`   ' ' '   \`-\`    :| "
  echo " |||:     ,______________.     :| "
  echo " |||...../::::o::::::o::::\.....| "
  echo " |^|..../:::O::::::::::O:::\....| "
  echo " |/\`---/--------------------\`---| "
  echo " \`.___/ /====/ /=//=/ /====/____/ "
  echo "      \`--------------------' "
  printf "\n\nSucessfully installed.\n\n"
  printf "${NORMAL}"
}

main