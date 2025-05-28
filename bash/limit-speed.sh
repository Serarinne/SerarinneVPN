#!/bin/bash
USER_LIST=$(grep -E ".*# .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 27)
USER_NAME=($(awk -F' ' '{print $0}' <<< "$USER_LIST"))
SPEED=700000
LIMIT_USAGE=10737418240
for USER in "${USER_NAME[@]}"
do
    USER_USAGE=$(grep -E "^${USER}#" "/root/serarinne/user-usage" | awk '{ gsub("#", " ") ; print $0 }' | cut -d ' ' -f 2)
    if [[ $USER_USAGE -gt $LIMIT_USAGE ]]; then
        sed -i '/server '${USER}' .*. # '${USER}' Backend/a     filter bwlim-out mydownloadlimit limit '${SPEED}' key be_id table limit_speed/downloadrate # '${USER}' Backend # '${USER}' Limit\n    http-response set-bandwidth-limit mydownloadlimit # '${USER}' Backend # '${USER}' Limit\n    filter bwlim-in myuploadlimit limit '${SPEED}' key be_id table limit_speed/uploadrate # '${USER}' Backend # '${USER}' Limit\n    http-request set-bandwidth-limit myuploadlimit # '${USER}' Backend # '${USER}' Limit' /etc/haproxy/haproxy.cfg
        systemctl restart haproxy
    fi
done
