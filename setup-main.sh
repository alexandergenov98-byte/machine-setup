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

    # Install VIM
    sudo apt install vim -y

    # Install VS code
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg > /dev/null
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt update
    sudo apt install code -y

    # Install Docker
    sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)
    # Add Docker's official GPG key:
    sudo apt update
    sudo apt install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    sudo usermod -aG docker $USER

    sudo apt install util-linux-extra -y
    #exec newgrp docker

    # Install wireshark
    echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
    sudo DEBIAN_FRONTEND=noninteractive apt install wireshark -y
    sudo usermod -aG wireshark $USER

    # Install Steam
    sudo dpkg --add-architecture i386
    sudo apt update
    sudo apt --fix-broken install
    sudo apt install steam-installer -y
    sudo sed -i 's/if \[ -n "\$new_installation" \]/if false echo/' $(which steam) # Remove install prompt
    steam 2>&1 1>/tmp/steam_install.log &

    # Install VLC Player
    sudo apt install vlc-bin -y

    # Install Viber
    sudo snap install --edge viber-official
    #  Apply these settings to allow the viber snap package to have access to microphone and camera
    #  sudo snap connect viber-official:camera
    #  sudo snap connect viber-official:audio-record

}

main (){
    [[ $# -lt 1 ]] && usage $@

    [[ $1 == '--setup' ]] && setup && exit 0

}

main $@
