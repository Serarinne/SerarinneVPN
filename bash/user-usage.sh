#!/bin/bash
XRAY_PORT=127.0.0.1:9999

USER_LIST=$(grep -E ".*# .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 27)
USER_NAME=($(awk -F' ' '{print $0}' <<< "$USER_LIST"))
for USER in "${USER_NAME[@]}"
do
    USER_UPLINK=$(xray api stats --server=$XRAY_PORT -name "user>>>${USER}>>>traffic>>>uplink" 2>/dev/null | jq '.stat.value')
    USER_DOWNLINK=$(xray api stats --server=$XRAY_PORT -name "user>>>${USER}>>>traffic>>>downlink" 2>/dev/null | jq '.stat.value')
    TOTAL_BANDWIDTH=$((USER_UPLINK + USER_DOWNLINK))

    USER_USAGE=$(grep -E "^${USER}#" "/root/serarinne/user-usage" | awk '{ gsub("#", " ") ; print $0 }' | cut -d ' ' -f 2)
    if [[ $USER_USAGE == "" ]] || [[ $USER_USAGE == null ]]; then
        echo "${USER}#${TOTAL_BANDWIDTH}" >> /root/serarinne/user-usage
    else
        TOTAL_USAGE=$((TOTAL_BANDWIDTH + USER_USAGE))
        sed -i "s/$USER#.*$/$USER#$TOTAL_USAGE/g" /root/serarinne/user-usage
    fi
done
xray api statsquery --server=$XRAY_PORT --reset=true > /dev/null 2>&1
limit-speed
