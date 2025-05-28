#!/bin/bash
USER_LIST=$(grep -E ".*# .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 27)
USER_NAME=($(awk -F' ' '{print $0}' <<< "$USER_LIST"))

for USER in "${USER_NAME[@]}"
do
    sed -i "/# ${USER} Limit/d" /etc/haproxy/haproxy.cfg
    systemctl restart haproxy
done