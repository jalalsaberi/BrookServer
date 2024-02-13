#!/bin/bash
# Compatible to Ubuntu ≥ 18
# https://github.com/jalalsaberi/BrookServer

BOLD="\e[1m"
UNDERLINE="\e[4m"
WHITE="\e[37m"
YELLOW="\e[33m"
BRIGHT_YELLOW="\e[93m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RED="\e[31m"
END="\e[0m"
version='v2.0.0'
github='https://github.com/jalalsaberi/BrookServer'
brook=("brook.service" "brookws.service" "brookwss.service")

banner() {
    echo -e "   ${MAGENTA}╔╗ ┬─┐┌─┐┌─┐┬┌─  ╔═╗┌─┐┬─┐┬  ┬┌─┐┬─┐${END}"
    echo -e "   ${MAGENTA}╠╩╗├┬┘│ ││ │├┴┐  ╚═╗├┤ ├┬┘└┐┌┘├┤ ├┬┘${END}"
    echo -e "   ${MAGENTA}╚═╝┴└─└─┘└─┘┴ ┴  ╚═╝└─┘┴└─ └┘ └─┘┴└─${END}"
    echo -e "${YELLOW}──────────────────────────────────────────${END}"
    echo -e "                 ${WHITE}$version${END}"
    echo -e "${YELLOW}──────────────────────────────────────────${END}"
    echo -e "${CYAN}${UNDERLINE}$github${END}"
    echo -e "${YELLOW}──────────────────────────────────────────${END}\n"
}

blink_str() {
    clear
    banner
    local msg=$1
    for i in {1..2}; do
        clear && echo -e "${YELLOW}$msg${END}"&& sleep 0.2
        clear && echo -e "${RED}$msg${END}" && sleep 0.2
        clear && echo -e "${YELLOW}$msg${END}"&& sleep 0.2
        clear && echo -e "${RED}$msg${END}" && sleep 0.2
    done
}

add_var() {
    local protocol="$1"
    local status="$2"
    if [ -f "$HOME/.brook-cli" ]; then
        source "$HOME/.brook-cli" > /dev/null
    fi
    if [[ $protocol == "br" ]]; then
        export "BROOK=$status"
        cat > "$HOME/.brook-cli" << EOF
export BROOK=$status
export BROOKWS=9
export BROOKWSS=9
export BROOKALL=9
EOF
    elif [[ $protocol == "ws" ]]; then
        export "BROOKWS=$status"
        cat > "$HOME/.brook-cli" << EOF
export BROOK=9
export BROOKWS=$status
export BROOKWSS=9
export BROOKALL=9
EOF
    elif [[ $protocol == "wss" ]]; then
        export "BROOKWSS=$status"
        cat > "$HOME/.brook-cli" << EOF
export BROOK=9
export BROOKWS=9
export BROOKWSS=$status
export BROOKALL=9
EOF
    elif [[ $protocol == "all" ]]; then
        export "BROOKALL=$status"
        cat > "$HOME/.brook-cli" << EOF
export BROOK=$status
export BROOKWS=$status
export BROOKWSS=$status
export BROOKALL=$status
EOF
    else
        blink_str "Invalid Input!!!"
        menu_cli
    fi
    if [ -f "$HOME/.brook-cli" ]; then
        source "$HOME/.brook-cli" > /dev/null
    fi
}

stop_service() {
    add_var "all" "9"
    count=0
    for service in "${brook[@]}"; do
        service_status=$(systemctl is-active $service)
        if [ "$service_status" = "active" ]; then
            systemctl stop "${brook[$count]}" && systemctl disable "${brook[$count]}"
            echo -e "${BOLD}${BRIGHT_YELLOW}$service_status${END} ${BRIGHT_YELLOW}Stopped Successfully.${END}"
            count+=1
        else
            continue
        fi
        echo -e "${BOLD}${BRIGHT_YELLOW}No Service${END} ${BRIGHT_YELLOW}is running.${END}"
    done
    systemctl reset-failed && systemctl daemon-reload
}

apt_up() {
    clear
    banner
    echo -e "${MAGENTA}${BOLD}[APT Update]${END}"
    sleep 0.5
    apt update -y
    apt install curl -y
}

nami_brook() {
    clear
    banner
    echo -e "${MAGENTA}${BOLD}[Installing Nami & Brook]${END}"
    sleep 0.5
    curl https://bash.ooo/nami.sh > nami.sh
    sed -i '/exec -l \$SHELL/d' nami.sh
    chmod +x nami.sh
    bash nami.sh
    rm -f nami.sh
    clear
    banner
    echo -e "${MAGENTA}${BOLD}[Installing Brook Server]${END}"
    sleep 0.5
    stop_service
    nami install brook
}

# Start
touch $HOME/.brook-cli
chmod +x $HOME/.brook-cli
cat > $HOME/.brook-cli <<EOF
export BROOK=9
export BROOKWS=9
export BROOKWSS=9
export BROOKALL=0
EOF
if [ -f "$HOME/.brook-cli" ]; then
    source "$HOME/.brook-cli" > /dev/null
fi
apt_up
curl -Ls https://raw.githubusercontent.com/jalalsaberi/BrookServer/main/cli.sh -o /usr/bin/brook-cli
chmod +x /usr/bin/brook-cli
nami_brook
source $HOME/.bashrc
brook-cli