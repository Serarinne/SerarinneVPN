#!/bin/bash
clear
echo -e "-----------------------------------------"
echo -e "|              Delete User              |"
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
    USER_DATE=$(grep -E ".*# ${USER_NAME} .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 28)
    sed -i "/# $USER_NAME $USER_DATE/d" /usr/local/etc/xray/config.json
    sed -i "/# $USER_NAME Frontend/d" /etc/haproxy/haproxy.cfg
    sed -i "/# $USER_NAME Backend/d" /etc/haproxy/haproxy.cfg
    read -p "$(echo -e "Back")"
    systemctl restart xray
    systemctl restart haproxy
    delete-user
fi
