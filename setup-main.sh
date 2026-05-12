#!/bin/bash

usage () {
    printf "usage %s <args>\n" $0
    printf " ARGS \n"
    printf " --dry-run \n"
    printf " --setup \n"

    exit 1
}

setup () {
    # Upgrade system
    sudo apt update && sudo apt upgrade -y

    # Setup Basic utilities
    sudo apt install wget curl gpg -y

    # Install VS code
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg > /dev/null
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt update
    sudo apt install code -y
}

main (){
    [[ $# -lt 1 ]] && usage $@

    [[ $1 -eq '--setup' ]] && setup
}

main $@
