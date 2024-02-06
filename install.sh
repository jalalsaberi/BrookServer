#!/bin/bash
# v1.0.0
# Tested on Ubuntu 22.04.3 LTS
# https://github.com/jalalsaberi/BrookServer

BOLD="\e[1m"
UNDERLINE="\e[4m"
WHITE="\e[37m"
GREEN="\e[32m"
YELLOW="\e[33m"
BRIGHT_YELLOW="\e[93m"
MAGENTA="\e[35m"
CYAN="\e[36m"
END="\e[0m"

success="${BOLD}${BRIGHT_YELLOW}Brook VPN Server${END} ${BRIGHT_YELLOW}Installed and Started Successfully.${END}"
service_name="brook.service"

add_service() {
    local command=$1
    cat > "/etc/systemd/system/brook.service" << EOF
[Unit]
Description=Brook Server

[Service]
ExecStart=$HOME/.nami/bin/$command
Restart=always

[Install]  
WantedBy=multi-user.target
EOF
    chmod +x /etc/systemd/system/brook.service
    systemctl daemon-reload
    systemctl enable brook.service
    systemctl start brook.service
}

is_ip() {
    local option=$1
    local password=$2
    local port=$3
    brook_path=$(which brook)
    brook_version=$($brook_path -v | awk '{print $3}')
    if [[ $option =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        add_service "brook server -l :$port -p $password"
        echo -e "${success}\n\n${CYAN}Brook Version:${END} $brook_version"
        echo -e "${CYAN}Brook IP:${END} $option\n${CYAN}Brook Password:${END} $password"
        echo -e "\n${UNDERLINE}${WHITE}https://github.com/jalalsaberi/BrookServer${END}\n"
    else
        add_service "brook wssserver --domainaddress $option:$port --password $password"
        echo -e "${success}\n\n${CYAN}Brook Version:${END} $brook_version"
        echo -e "${CYAN}Brook Domain:${END} ${UNDERLINE}$option${END}\n${CYAN}Brook Password:${END} $password\n${CYAN}Brook WSS URI:${END} ${UNDERLINE}wss://$option:$port${END}"
        echo -e "\n${UNDERLINE}${WHITE}https://github.com/jalalsaberi/BrookServer${END}\n"
    fi
}

clear
echo -e "${MAGENTA}${BOLD}[apt Update & Upgrade]${END}"
sleep 0.5
apt update && apt upgrade -y
clear
if systemctl is-active --quiet "$service_name" && systemctl is-enabled --quiet "$service_name"; then
    echo -e "${MAGENTA}${BOLD}[Stopping Brook Service]${END}"
    sleep 0.5
    systemctl stop "$service_name"
    clear
else
    continue
fi
echo -e "${MAGENTA}${BOLD}[Installing Nami]${END}"
sleep 0.5
curl https://bash.ooo/nami.sh > nami.sh
sed -i '/exec -l \$SHELL/d' nami.sh
chmod +x nami.sh
bash nami.sh
source $HOME/.bashrc
source $HOME/.bash_profile
clear
echo -e "${MAGENTA}${BOLD}[Installing Brook Server]${END}"
sleep 0.5
nami install brook
rm -f nami.sh
clear
echo -e "${MAGENTA}${BOLD}[Setting Server VARS]${END}"
sleep 0.5
echo -en "${YELLOW}Enter your server IP or Domain/Subdomain:${END} " && read option
echo -en "${YELLOW}Enter your Password:${END} " && read password
echo -en "${YELLOW}Enter your Port:${END} " && read port
clear
is_ip "$option" "$password" "$port"
systemctl restart "$service_name"