#!/bin/bash
clear
echo -e "-----------------------------------------"
echo -e "|          User Bandwidth Usage         |"
echo -e "-----------------------------------------"
echo ""
XRAY_PORT=127.0.0.1:9999

XRAY_DATA () {
    USER_LIST=$(grep -E ".*# .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 27)
    USER_NAME=($(awk -F' ' '{print $0}' <<< "$USER_LIST"))
    for USER in "${USER_NAME[@]}"
    do
        USER_USAGE=$(grep -E "^${USER}#" "/root/serarinne/user-usage" | awk '{ gsub("#", " ") ; print $0 }' | cut -d ' ' -f 2)

        echo $USER $USER_USAGE | numfmt --field=2 --format "%.2f" --suffix=B --to=iec | awk '{ gsub(" ", "#") ; print $0 }'
    done
}

USERS_DATA=$(XRAY_DATA $1)
echo "USER#USAGE ${USERS_DATA}" | tr ' ' '\n' | tr '#' ' ' | column -t
echo ""
read -p "$(echo -e "Back")"
menu
