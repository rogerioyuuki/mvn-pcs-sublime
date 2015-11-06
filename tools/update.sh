#!/bin/bash
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

# LINUX or OSX Sublime path:
SUBLIME_OSX=~/Library/Application\ Support/Sublime\ Text\ 3/Packages
SUBLIME_LINUX=~/.config/sublime-text-3/Packages

# Detect OS:
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  SUBLIME=$SUBLIME_LINUX
elif [[ "$OSTYPE" == "darwin"* ]]; then
  SUBLIME=$SUBLIME_OSX
elif [[ "$OSTYPE" == "cygwin" ]]; then
  echo "${RED}To install on Windows, refer to the README.${NORMAL}\n"
  exit 1
else
  echo "${RED}It wasn't possible to detect your operating system. Please refer to manual installation.${NORMAL}\n"
  exit 1
fi

# Set installation folder
INSTALL=$SUBLIME/mvn-pcs-sublime

# Check if installed:
if [ ! -d "$INSTALL" ]; then
  printf "${RED}MVN PCS Sublime is not installed.${NORMAL}\n"
  exit 1
fi


printf "${BLUE}%s${NORMAL}\n" "Updating MVN PCS Sublime..."
cd "$INSTALL"
if git pull --rebase --stat origin master
then
  printf '%s' "$GREEN"
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
  echo ""
  printf "${BLUE}%s\n\n" "MVN PCS has been updated!"
else
  printf "${RED}%s${NORMAL}\n" 'There was an error updating. Try reinstalling.'
  exit 1
fi