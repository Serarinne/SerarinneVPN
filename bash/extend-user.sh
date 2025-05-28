#!/bin/bash
clear
echo -e "-----------------------------------------"
echo -e "|              Extend User              |"
echo -e "-----------------------------------------"
echo ""

XRAY_DATA () {
    USER_LIST=$(grep -E ".*# .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 27)
    USER_NAME=($(awk -F' ' '{print $0}' <<< "$USER_LIST"))

    for USER in "${USER_NAME[@]}"
    do
        USER_DATA=$(grep -E ".*# ${USER} .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 27-28)
        echo $USER_DATA | awk '{ gsub(" ", "#") ; print $0 }'
    done
}

USERS_DATA=$(XRAY_DATA $1)
echo "USER#EXP ${USERS_DATA}" | tr ' ' '\n' | tr '#' ' ' | column -t
echo ""
read -rp "Username [0 for back]: " USER_NAME
if [[ $USER_NAME == 0 ]]; then
    menu
else
    read -rp "Extend until [DD-MM-YYYY]: " NEW_DATE
    USER_DATE=$(grep -E ".*# ${USER_NAME} .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 28)
    sed -i "s/# $USER_NAME $USER_DATE$/# $USER_NAME $NEW_DATE/g" /usr/local/etc/xray/config.json
    read -p "$(echo -e "Back")"
    systemctl restart xray
    extend-user
fi