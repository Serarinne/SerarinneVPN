#!/bin/bash
USER_LIST=$(grep -E ".*# .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 27)
USER_NAME=($(awk -F' ' '{print $0}' <<< "$USER_LIST"))
CURRENT_DATE=`date +"%d-%m-%Y"`

for USER in "${USER_NAME[@]}"
do
    USER_EXPIRED=$(grep -E ".*# ${USER} ${CURRENT_DATE}" "/usr/local/etc/xray/config.json" | wc -l)

    if [[ "$USER_EXPIRED" == "1" ]]; then
        sed -i "/# $USER $CURRENT_DATE/d" /usr/local/etc/xray/config.json
        sed -i "/# $USER Frontend/d" /etc/haproxy/haproxy.cfg
        sed -i "/# $USER Backend/d" /etc/haproxy/haproxy.cfg
        echo "${USER} deleted"
        systemctl restart xray
        systemctl restart haproxy
    fi
done