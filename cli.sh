#!/bin/bash
# Compatible with Ubuntu ≥ 18 || Debian ≥ 10
# https://github.com/jalalsaberi/BrookServer

BOLD="\e[1m"
UNDERLINE="\e[4m"
WHITE="\e[37m"
YELLOW="\e[33m"
BRIGHT_YELLOW="\e[93m"
MAGENTA="\e[35m"
CYAN="\e[36m"
GREEN="\e[32m"
BRIGHT_GREEN="\e[92m"
RED="\e[31m"
END="\e[0m"
version='v2.0.2'
github='https://github.com/jalalsaberi/BrookServer'
sign="\n${BOLD}${BRIGHT_YELLOW}BrookServer $version${END} : ${UNDERLINE}${WHITE}$github${END}\n"
brook=("brook.service" "brookws.service" "brookwss.service")
ip_input="${YELLOW}Enter your server IP: ${END}"
domain_input="${YELLOW}Enter your server Domain or Subdomain: ${END}"
pass_input="${YELLOW}Enter your server Password: ${END}"
port_input="${YELLOW}Enter your server Port: ${END}"

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

add_var() {
    local protocol="$1"
    local status="$2"
    if [ -f "$HOME/.brook-cli" ]; then
        source "$HOME/.brook-cli" > /dev/null
    fi 
    if [[ $protocol == "br" ]]; then
        export "BROOK=$status"
        sed -i '/^export BROOK=/d' "$HOME/.brook-cli" && echo "export BROOK=$status" >> "$HOME/.brook-cli"
    elif [[ $protocol == "ws" ]]; then
        export "BROOKWS=$status"
        sed -i '/^export BROOKWS=/d' "$HOME/.brook-cli" && echo "export BROOKWS=$status" >> "$HOME/.brook-cli"
    elif [[ $protocol == "wss" ]]; then
        export "BROOKWSS=$status"
        sed -i '/^export BROOKWSS=/d' "$HOME/.brook-cli" && echo "export BROOKWSS=$status" >> "$HOME/.brook-cli"
    elif [[ $protocol == "all" ]]; then
        export "BROOK=$status"
        export "BROOKWS=$status"
        export "BROOKWSS=$status"
        export "BROOKALL=$status"
        sed -i '/^export BROOK=/d' "$HOME/.brook-cli" && echo "export BROOK=$status" >> "$HOME/.brook-cli"
        sed -i '/^export BROOKWS=/d' "$HOME/.brook-cli" && echo "export BROOKWS=$status" >> "$HOME/.brook-cli"
        sed -i '/^export BROOKWSS=/d' "$HOME/.brook-cli" && echo "export BROOKWSS=$status" >> "$HOME/.brook-cli"
        sed -i '/^export BROOKALL=/d' "$HOME/.brook-cli" && echo "export BROOKALL=$status" >> "$HOME/.brook-cli"
    else
        blink_str "Invalid Input!!!"
        menu_cli
    fi
    if [ -f "$HOME/.brook-cli" ]; then
        source "$HOME/.brook-cli" > /dev/null
    fi
}

service_status () {
    clear
    banner
    if [ -f "$HOME/.brook-cli" ]; then
        source "$HOME/.brook-cli" > /dev/null
    fi
    declare -a services=("BROOK" "BROOKWS" "BROOKWSS" "BROOKALL")
    for service in "${services[@]}"; do
        value="${!service}"
        case $service in
            BROOK)
                br_val=$value
                ;;
            BROOKWS)
                ws_val=$value
                ;;
            BROOKWSS)
                wss_val=$value
                ;;
            BROOKALL)
                all_val=$value
                ;;
        esac
    done
    stat=("$br_val" "$ws_val" "$wss_val" "$all_val")
    for ((count=0; count<${#stat[@]}; count++)); do
        if [[ ${stat[count]} == "1" ]]; then
            stat[$count]="${BRIGHT_GREEN}Active${END}"
        elif [[ ${stat[count]} == "0" ]]; then
            stat[$count]="${RED}Deactive${END}"
        else
            stat[$count]="${BRIGHT_YELLOW}Not Created or Removed!${END}"
        fi
    done
    echo -e "${YELLOW}1) brook.service: ${END}${stat[0]}"
    echo -e "${YELLOW}2) brookws.service: ${END}${stat[1]}"
    echo -e "${YELLOW}3) brookwss.service: ${END}${stat[2]}"
    if [[ $br_val == "1" && $ws_val == "1" && $wss_val == "1" ]]; then
        echo -e "${YELLOW}4) All Services: ${END}${BRIGHT_GREEN}Active${END}"
    else
        echo -e "${YELLOW}4) All Services: ${END}${BRIGHT_YELLOW}Not Active${END}"
    fi
}

stop_service() {
    service_status
    echo -en "\n${BRIGHT_YELLOW}Choose: ${END}" && read service
    if [[ $service == "1" ]]; then
        add_var "br" "0"
        systemctl stop "${brook[0]}" && systemctl disable "${brook[0]}"
        echo -e "\n${BOLD}${BRIGHT_YELLOW}${brook[0]}${END} ${BRIGHT_YELLOW}Stopped Successfully.${END}"
    elif [[ $service == "2" ]]; then
        add_var "ws" "0"
        systemctl stop "${brook[1]}" && systemctl disable "${brook[1]}"
        echo -e "\n${BOLD}${BRIGHT_YELLOW}${brook[1]}${END} ${BRIGHT_YELLOW}Stopped Successfully.${END}"
    elif [[ $service == "3" ]]; then
        add_var "wss" "0"
        systemctl stop "${brook[2]}" && systemctl disable "${brook[2]}"
        echo -e "\n${BOLD}${BRIGHT_YELLOW}${brook[2]}${END} ${BRIGHT_YELLOW}Stopped Successfully.${END}"
    elif [[ $service == "4" ]]; then
        add_var "all" "0"
        count=0
        for service in "${brook[@]}"; do
            systemctl stop "${brook[$count]}" && systemctl disable "${brook[$count]}"
            count+=1
        done
        echo -e "\n${BOLD}${BRIGHT_YELLOW}All Services${END} ${BRIGHT_YELLOW}Stopped Successfully.${END}"
    fi
    systemctl reset-failed && systemctl daemon-reload
}

start_service() {
    service_status
    echo -en "\n${BRIGHT_YELLOW}Choose: ${END}" && read service
    if [[ $service == "1" ]]; then
        add_var "br" "1"
        systemctl enable "${brook[0]}" && systemctl start "${brook[0]}"
        echo -e "\n${BOLD}${BRIGHT_YELLOW}${brook[0]}${END} ${BRIGHT_YELLOW}Started Successfully.${END}"
    elif [[ $service == "2" ]]; then
        add_var "ws" "1"
        systemctl enable "${brook[1]}" && systemctl start "${brook[1]}"
        echo -e "\n${BOLD}${BRIGHT_YELLOW}${brook[1]}${END} ${BRIGHT_YELLOW}Started Successfully.${END}"
    elif [[ $service == "3" ]]; then
        add_var "wss" "1"
        systemctl enable "${brook[2]}" && systemctl start "${brook[2]}"
        echo -e "\n${BOLD}${BRIGHT_YELLOW}${brook[2]}${END} ${BRIGHT_YELLOW}Started Successfully.${END}"
    elif [[ $service == "4" ]]; then
        add_var "all" "1"
        count=0
        for service in "${brook[@]}"; do
            systemctl enable "${brook[$count]}" && systemctl start "${brook[$count]}"
            count+=1
        done
        echo -e "\n${BOLD}${BRIGHT_YELLOW}All Services${END} ${BRIGHT_YELLOW}Started Successfully.${END}"
    fi
    systemctl reset-failed && systemctl daemon-reload
}

blink_str() {
    clear
    banner
    local msg=$1
    for i in {1..2}; do
        clear && banner && echo -e "${YELLOW}$msg${END}"&& sleep 0.2
        clear && banner && echo -e "${RED}$msg${END}" && sleep 0.2
        clear && banner && echo -e "${YELLOW}$msg${END}"&& sleep 0.2
        clear && banner && echo -e "${RED}$msg${END}" && sleep 0.2
    done
}

restart_brook() {
    service_status
    echo -en "\n${BRIGHT_YELLOW}Choose: ${END}" && read service
    if [[ $service == "1" ]]; then
        systemctl restart "${brook[0]}"
        echo -e "\n${BOLD}${BRIGHT_YELLOW}${brook[0]}${END} ${BRIGHT_YELLOW}Restarted Successfully.${END}"
    elif [[ $service == "2" ]]; then
        systemctl restart "${brook[0]}"
        echo -e "\n${BOLD}${BRIGHT_YELLOW}${brook[1]}${END} ${BRIGHT_YELLOW}Restarted Successfully.${END}"
    elif [[ $service == "3" ]]; then
        systemctl restart "${brook[0]}"
        echo -e "\n${BOLD}${BRIGHT_YELLOW}${brook[2]}${END} ${BRIGHT_YELLOW}Restarted Successfully.${END}"
    elif [[ $service == "4" ]]; then
        count=0
        for service in "${brook[@]}"; do
            systemctl restart "${brook[0]}"
            count+=1
        done
        echo -e "\n${BOLD}${BRIGHT_YELLOW}All Services${END} ${BRIGHT_YELLOW}Restarted Successfully.${END}"
    fi
    systemctl reset-failed && systemctl daemon-reload
}

add_service() {
    local command=$1
    local brook_service=$2
    local name=$3
    cat > "/etc/systemd/system/$brook_service" << EOF
[Unit]
Description=$name

[Service]
ExecStart=$command
Restart=always

[Install]  
WantedBy=multi-user.target
EOF
    declare -a services=("BROOK" "BROOKWS" "BROOKWSS" "BROOKALL")
    for service in "${services[@]}"; do
        value="${!service}"
        case $service in
            BROOK)
                br_val=$value
                ;;
            BROOKWS)
                ws_val=$value
                ;;
            BROOKWSS)
                wss_val=$value
                ;;
            BROOKALL)
                all_val=$value
                ;;
        esac
    done
    if [[ "$brook_service" == "${brook[0]}" ]]; then
        if [[ "$br_val" == "0" ]]; then
            chmod +x /etc/systemd/system/$brook_service
            systemctl daemon-reload
            systemctl enable $brook_service
            systemctl start $brook_service
            add_var "br" "1"
        else
            systemctl daemon-reload
            systemctl restart $brook_service
        fi
    elif [[ "$brook_service" == "${brook[1]}" ]]; then
        if [[ "$br_val" == "0" ]]; then
            chmod +x /etc/systemd/system/$brook_service
            systemctl daemon-reload
            systemctl enable $brook_service
            systemctl start $brook_service
            add_var "ws" "1"
        else
            systemctl daemon-reload
            systemctl restart $brook_service
        fi
    elif [[ "$brook_service" == "${brook[2]}" ]]; then
        if [[ "$br_val" == "0" ]]; then
            chmod +x /etc/systemd/system/$brook_service
            systemctl daemon-reload
            systemctl enable $brook_service
            systemctl start $brook_service
            add_var "wss" "1"
        else
            systemctl daemon-reload
            systemctl restart $brook_service
        fi
    fi
}

define_protocol() {
    clear
    banner
    brook_path=$(which brook)
    brook_version=$($brook_path -v | awk '{print $3}')
    local protocol=$1
    echo -e "${MAGENTA}${BOLD}[Enter Your Server Information]${END}\n"
    if [[ $protocol == "all" ]]; then
        echo -en $ip_input && read ip
        echo -en $domain_input && read domain
    elif [[ $protocol == "wss" ]]; then
        echo -en $domain_input && read connect
    else
        echo -en $ip_input && read connect
    fi
    if [[ $protocol == "all" ]]; then
        echo -en "${YELLOW}Enter your WSS server Port: ${END}" && read portwss
        echo -en "${YELLOW}Enter your WS server Port: ${END}" && read portws
        echo -en "${YELLOW}Enter your Brook server Port: ${END}" && read portbrook
    else
        echo -en $port_input && read port
    fi
    echo -en $pass_input && read pass
    if [[ $protocol == "ws" ]]; then
        add_service "$brook_path wsserver -l :$port -p $pass" "${brook[1]}" "Brook WS Server"
        add_var "$protocol" "1"
        clear
        banner
        echo -e "${BOLD}${BRIGHT_YELLOW}WS VPN Server${END} ${BRIGHT_YELLOW}Installed and Started Successfully.${END}\n"
        echo -e "\n${CYAN}Brook Version:${END} $brook_version"
        echo -e "${CYAN}WS Server IP:${END} $connect\n${CYAN}WS Server Password:${END} $pass\n${CYAN}WS Server URI:${END} ws://$connect:$port"
    elif [[ $protocol == "wss" ]]; then
        add_service "$brook_path wssserver --domainaddress $connect:$port -p $pass" "${brook[2]}" "Brook WSS Server"
        add_var "$protocol" "1"
        clear
        banner
        echo -e "${BOLD}${BRIGHT_YELLOW}WSS VPN Server${END} ${BRIGHT_YELLOW}Installed and Started Successfully.${END}\n"
        echo -e "\n${CYAN}Brook Version:${END} $brook_version"
        echo -e "${CYAN}WSS Server Domain:${END} $connect\n${CYAN}WSS Server Password:${END} $pass\n${CYAN}WSS Server URI:${END} wss://$connect:$port"
    elif [[ $protocol == "all" ]]; then
        add_service "$brook_path wsserver -l :$portws -p $pass" "${brook[1]}" "Brook WS Server"
        add_service "$brook_path wssserver --domainaddress $domain:$portwss -p $pass" "${brook[2]}" "Brook WSS Server"
        add_service "$brook_path server -l :$portbrook -p $pass" "${brook[0]}" "Brook Server"
        add_var "$protocol" "1"
        clear
        banner
        echo -e "${BOLD}${BRIGHT_YELLOW}All VPN Servers${END} ${BRIGHT_YELLOW}Installed and Started Successfully.${END}\n"
        echo -e "\n${CYAN}Brook Version:${END} $brook_version"
        echo -e "${CYAN}Server IP:${END} $ip\n${CYAN}Server Domain:${END} $domain\n${CYAN}Server Password:${END} $pass"
        echo -e "${CYAN}WSS Server URI:${END} wss://$domain:$portwss"
        echo -e "${CYAN}WS Server URI:${END} ws://$ip:$portws"
        echo -e "${CYAN}Brook Server IP & Port:${END} $ip:$portbrook"
    else
        add_service "$brook_path server -l :$port -p $pass" "${brook[0]}" "Brook Server"
        add_var "br" "1"
        clear
        banner
        echo -e "${BOLD}${BRIGHT_YELLOW}Brook VPN Server${END} ${BRIGHT_YELLOW}Installed and Started Successfully.${END}\n"
        echo -e "\n${CYAN}Brook Version:${END} $brook_version"
        echo -e "${CYAN}Brook Server IP & Port:${END} $connect:$port\n${CYAN}Brook Server Password:${END} $pass"
    fi
    echo -e $sign
    echo -en "\n${BRIGHT_YELLOW}Enter 1 to back to main menu OR 0 to Exit: ${END}" && read where
    if [[ $where == "0" ]]; then
        exit
    elif [[ $where == "1" ]]; then
        menu_cli
    else
        exit
    fi
}

add_server() {
    blink_str "*** Recommended Protocol is WSS Server on Port 443 Using a Domain/Subdomain with Cloudflare Proxy ON ***\n"
    echo -e "${MAGENTA}${BOLD}[Choose Your Protocol]${END}\n"
    echo -e "${YELLOW}1) WSS Server (Uses Domain or Subdomain)${END}"
    echo -e "${YELLOW}2) WS Server (Uses IPv4)${END}"
    echo -e "${YELLOW}3) Brook Server (Uses IPv4)${END}"
    echo -e "${YELLOW}4) All Servers${END}"
    echo -e "${YELLOW}5) Back to main menu${END}"
    echo -e "${YELLOW}0) Exit)${END}\n"
    echo -en "${YELLOW}Choose: ${END}" && read protocol
    if [[ $protocol == 1 ]]; then
        define_protocol "wss"
    elif [[ $protocol == 2 ]]; then
        define_protocol "ws"
    elif [[ $protocol == 3 ]]; then
        define_protocol "brook"
    elif [[ $protocol == 4 ]]; then
        define_protocol "all"
    elif [[ $protocol == 5 ]]; then
        options
    elif [[ $protocol == 0 ]]; then
        exit
    else
        blink_str "Invalid Input!!!"
        add_server
    fi
}

remove_server() {
    service_status
    echo -en "\n${BRIGHT_YELLOW}Choose: ${END}" && read choice
    if [[ $choice == "1" ]]; then
        systemctl stop "${brook[0]}"
        systemctl disable "${brook[0]}"
        rm -f "/etc/systemd/system/${brook[0]}"
        echo -e "\n${BOLD}${BRIGHT_YELLOW}${brook[0]}${END} ${BRIGHT_YELLOW}Removed Successfully.${END}"
        systemctl reset-failed && systemctl daemon-reload
        add_var "br" "9"
    elif [[ $choice == "2" ]]; then
        systemctl stop "${brook[10]}"
        systemctl disable "${brook[1]}"
        rm -f "/etc/systemd/system/${brook[1]}"
        echo -e "\n${BOLD}${BRIGHT_YELLOW}${brook[1]}${END} ${BRIGHT_YELLOW}Removed Successfully.${END}"
        systemctl reset-failed && systemctl daemon-reload
        add_var "ws" "9"
    elif [[ $choice == "3" ]]; then
        systemctl stop "${brook[1]}"
        systemctl disable "${brook[1]}"
        rm -f "/etc/systemd/system/${brook[1]}"
        echo -e "\n${BOLD}${BRIGHT_YELLOW}${brook[1]}${END} ${BRIGHT_YELLOW}Removed Successfully.${END}"
        systemctl reset-failed && systemctl daemon-reload
        add_var "wss" "9"
    elif [[ $choice == "4" ]]; then
        for service in "${brook[@]}"; do
            systemctl stop "$service" > /dev/null
            systemctl disable "$service" > /dev/null
            rm -f "/etc/systemd/system/$service" > /dev/null
            systemctl reset-failed && systemctl daemon-reload
        done
        echo -e "\n${BOLD}${BRIGHT_YELLOW}All Services${END} ${BRIGHT_YELLOW}Removed Successfully.${END}"
        add_var "all" "9"
    else
        clear
        banner
        blink_str "Invalid Input!!!"
        remove_server
    fi
}

options() {
    clear
    banner
    echo -e "${BRIGHT_YELLOW}1) Check servers status${END}"
    echo -e "${BRIGHT_YELLOW}2) Add new server${END}"
    echo -e "${BRIGHT_YELLOW}3) Change server Info.${END}"
    echo -e "${BRIGHT_YELLOW}4) Stop server${END}"
    echo -e "${BRIGHT_YELLOW}5) Start server${END}"
    echo -e "${BRIGHT_YELLOW}6) Restart server${END}"
    echo -e "${BRIGHT_YELLOW}7) Remove server${END}"
    echo -e "${BRIGHT_YELLOW}8) Uninstall BrookServer${END}"
    echo -e "${BRIGHT_YELLOW}0) Exit${END}"
    echo -en "${BRIGHT_YELLOW}\nSelect option: ${END}" && read userinput
    if [[ $userinput == "1" ]]; then
        service_status
        echo -en "\n${BRIGHT_YELLOW}Enter 1 to back to main menu OR 0 to Exit: ${END}" && read where
        if [[ $where == "0" ]]; then
            exit
        elif [[ $where == "1" ]]; then
            menu_cli
        else
            exit
        fi
    elif [[ $userinput == "2" ]]; then
        add_server
        restart_brook
    elif [[ $userinput == "3" ]]; then
        add_server
        restart_brook
    elif [[ $userinput == "4" ]]; then
        clear
        banner
        stop_service
        echo -en "\n${BRIGHT_YELLOW}Enter 1 to back to main menu OR 0 to Exit: ${END}" && read where
        if [[ $where == "0" ]]; then
            exit
        elif [[ $where == "1" ]]; then
            menu_cli
        else
            exit
        fi
    elif [[ $userinput == "5" ]]; then
        clear
        banner
        start_service
        echo -en "\n${BRIGHT_YELLOW}Enter 1 to back to main menu OR 0 to Exit: ${END}" && read where
        if [[ $where == "0" ]]; then
            exit
        elif [[ $where == "1" ]]; then
            menu_cli
        else
            exit
        fi
    elif [[ $userinput == "6" ]]; then
        clear
        banner
        restart_brook
        echo -en "\n${BRIGHT_YELLOW}Enter 1 to back to main menu OR 0 to Exit: ${END}" && read where
        if [[ $where == "0" ]]; then
            exit
        elif [[ $where == "1" ]]; then
            menu_cli
        else
            exit
        fi
    elif [[ $userinput == "7" ]]; then
        clear
        banner
        remove_server
        echo -en "\n${BRIGHT_YELLOW}Enter 1 to back to main menu OR 0 to Exit: ${END}" && read where
        if [[ $where == "0" ]]; then
            exit
        elif [[ $where == "1" ]]; then
            menu_cli
        else
            exit
        fi
        restart_brook
    elif [[ $userinput == "8" ]]; then
        service_status
        remove_server
        nami remove brook 
        rm -rf $HOME/.nami
        rm -rf $HOME/.brook-cli
        source $HOME/.bashrc
        if [ -f "$HOME/.brook-cli" ]; then
            source "$HOME/.brook-cli" > /dev/null
        fi
        if [ -x "$(command -v nami)" ]; then
            echo -e "${RED}Error: Nami Uninstall Failed${END}" >&2
        else
            continue
        fi
        clear
        banner
        echo -e "${BRIGHT_YELLOW}BrookServer Uninstalled Successfully.${END}"
        echo -e $sign
        rm -rf /usr/bin/brook-cli
        source $HOME/.bashrc
        exit
    elif [[ $userinput == "0" ]]; then
        exit
    else
        exit
    fi
}

menu_cli() {
    options
}

display_version() {
    echo -e "${BRIGHT_YELLOW}BrookServer: ${END}${WHITE}$version${END}"
    echo -e "${BRIGHT_YELLOW}Github: ${END}${UNDERLINE}${WHITE}$github${END}\n"
}

display_help() {
    echo "CLI Menu: brook-cli"
    echo "Usage: brook-cli [OPTIONS]"
    echo "Options:"
    echo "  -h, --help          Display help"
    echo "  -v, --version       Display the version"
    echo "  -a, --add           Add new server & service"
    echo "                      (if protocol you choose is currently running, this command will replace it with new information you enter.)"
    echo "  -r, --remove        Remove current BrookServer servers & services"
    echo "  -u, --uninstall     Uninstall BrookServer"
}

if [ -f "$HOME/.brook-cli" ]; then
    source "$HOME/.brook-cli" > /dev/null
fi
if [ $# -eq 0 ]; then
    source $HOME/.bashrc
    menu_cli
else
    case "$1" in
        -h|--help)
            display_help
            ;;
        -v|--version)
            display_version
            ;;
        *)
            display_help
            ;;
    esac
fi
