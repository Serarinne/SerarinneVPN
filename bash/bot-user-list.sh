#!/bin/bash
XRAY_PORT=127.0.0.1:9999

XRAY_DATA () {
    local USER_LIST=$(grep -E ".*# .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 27)
    USER_NAME=($(awk -F' ' '{print $0}' <<< "$USER_LIST"))

    for USER in "${USER_NAME[@]}"
    do
	USER_DATA=$(grep -E ".*# ${USER} .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 27-28)
        echo $USER_DATA | awk '{ gsub(" ", " ") ; print $0 }'
    done
}
TOTAL_USER=$(grep -c -E ".*# .*" "/usr/local/etc/xray/config.json")
LOGIN_DATA=$(XRAY_DATA $1)
echo "Total User : ${TOTAL_USER}"
echo "${LOGIN_DATA}" | nl | column -t
