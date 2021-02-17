#!/bin/bash

set -e

SCRIPT_VERSION="v0.1"
NAME_INSTALLER="SERVERNAME"
AUTHOR="Dawid Jan Korytkowski"

# exit with error status code if user is not root
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

# check for curl
if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives) or yum/dnf (CentOS)"
  exit 1
fi

output() {
  echo -e "* ${1}"
}

error() {
  COLOR_RED='\033[0;31m'
  COLOR_NC='\033[0m'

  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_NC}: $1"
  echo ""
}

done=false

output "███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ ███╗   ██╗ █████╗ ███╗   ███╗███████╗"
output "██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗████╗  ██║██╔══██╗████╗ ████║██╔════╝"
output "███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝██╔██╗ ██║███████║██╔████╔██║█████╗  "
output "╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝  "
output " ██████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗"
output "╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝"
output
output "[$NAME_INSTALLER] ➤ Pterodactyl Installer"
output "[$NAME_INSTALLER] ➤ Version: $SCRIPT_VERSION"
output "[$NAME_INSTALLER] ➤ Author: $AUTHOR"
output
output "Some message will be here because yeah why the fuck no..."
output
output "(( Not official installer of pterodactyl. | Not for commercial use. ))"

output

panel() {
  bash <(curl -s https://raw.githubusercontent.com/Mr0Eagle/PT-Installer/$SCRIPT_VERSION/install-panel.sh)
}

wings() {
  bash <(curl -s https://raw.githubusercontent.com/Mr0Eagle/PT-Installer/$SCRIPT_VERSION/install-wings.sh)
}

while [ "$done" == false ]; do
  options=(
    "[●] Installation of Panel (ONLY)"
    "[●] Installation of Daemon (ONLY)"
    "[●] Installation of Both Panel & Daemon\n"
  )

  actions=(
    "panel"
    "wings"
    "panel; wings"
  )

  output "[$NAME_INSTALLER] ➤ Choose Option"

  for i in "${!options[@]}"; do
    output "[$i] ${options[$i]}"
  done

  echo -n "* Input 0-$((${#actions[@]}-1)): "
  read -r action

  [ -z "$action" ] && error "Input is required" && continue

  valid_input=("$(for ((i=0;i<=${#actions[@]}-1;i+=1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Invalid option"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && eval "${actions[$action]}"
done
