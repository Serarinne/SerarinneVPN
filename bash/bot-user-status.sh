#!/bin/bash
clear
XRAY_PORT=127.0.0.1:9999
TODAY_USAGE=$(vnstat -d --oneline | awk -F\; '{print $6}' | sed 's/ //')
MONTH_USAGE=$(vnstat -m --oneline | awk -F\; '{print $11}' | sed 's/ //')

XRAY_DATA () {
    USER_LIST=$(grep -E ".*# .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 27)
    USER_NAME=($(awk -F' ' '{print $0}' <<< "$USER_LIST"))
    for USER in "${USER_NAME[@]}"
    do
        USER_USAGE=$(grep -E "^${USER}#" "/root/serarinne/user-usage" | awk '{ gsub("#", " ") ; print $0 }' | cut -d ' ' -f 2)

        LIMITED_USER=$(grep -E ".*# ${USER} Backend # ${USER} Limit" "/etc/haproxy/haproxy.cfg" | wc -l)
        if [[ $LIMITED_USER -gt 0 ]]; then
            USER_STATUS="#DIBATASI"
        else
            USER_STATUS="#"
        fi
        echo $USER $USER_USAGE $USER_STATUS | numfmt --field=2 --format "%.2f" --suffix=B --to=iec | awk '{ gsub(" ", "#") ; print $0 }'
    done
}

user-usage > /dev/null 2>&1
USERS_DATA=$(XRAY_DATA $1)
echo -e "Quota Hari Ini   : $TODAY_USAGE"
echo -e "Quota Bulan Ini  : $MONTH_USAGE"
echo ""
echo "USER#QUOTA#STATUS ${USERS_DATA}" | tr ' ' '\n' | tr '#' ' ' | column -t
