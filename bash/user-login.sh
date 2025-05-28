#!/bin/bash
clear
echo -e "-----------------------------------------"
echo -e "|               User Login              |"
echo -e "-----------------------------------------"
echo ""
XRAY_PORT=127.0.0.1:9999

XRAY_DATA () {
    local USER_LIST=$(grep -E ".*# .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 27)
    USER_NAME=($(awk -F' ' '{print $0}' <<< "$USER_LIST"))

    for USER in "${USER_NAME[@]}"
    do
        local USER_IP=$(xray api statsonlineiplist --server=$XRAY_PORT --email="${USER}" 2>/dev/null | jq '.ips' | awk '{ gsub("\"", "") ; print $0 }' | sed 's/[^a-zA-Z0-9.:]//g' | tr '\n' ' ')

        if [[ $USER_IP == *":"* ]]; then
            TOTAL_IP=$(echo "$USER_IP" | grep -o ':' | wc -l)
            ONLINE_STATUS="Online#${TOTAL_IP}"
        else
            ONLINE_STATUS="Offline#0"
        fi

        echo -e "${USER}#${ONLINE_STATUS}"
    done
}

LOGIN_DATA=$(XRAY_DATA $1)
echo "USER#STATUS#TOTAL ${LOGIN_DATA}" | tr ' ' '\n' | tr '#' ' ' | column -t
echo ""
read -p "$(echo -e "Back")"
menu
