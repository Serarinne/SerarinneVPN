#!/bin/bash
clear
SERVER_BUG=$(cat /root/serarinne/bug)
SERVER_CF=$(cat /root/serarinne/cloudflare)
SERVER_DOMAIN=$(cat /root/serarinne/domain)
SERVER_NAME=$(cat /root/serarinne/name)
SERVER_IP=$(cat /root/serarinne/ip)

until [[ $USER_NAME =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
    USER_NAME=$1
    CLIENT_EXISTS=$(grep -w $USER_NAME /usr/local/etc/xray/config.json | wc -l)
    
    if [[ ${CLIENT_EXISTS} == '1' ]]; then
        echo "2"
    fi
done

ACTIVE_PERIOD=30
USER_ID=$2
USER_DATE=`date -d "$ACTIVE_PERIOD days" +"%d-%m-%Y"`
USER_PORT=10000

until [[ ${CHECKED_PORT} == '0' ]]; do
    ((USER_PORT++))
    CHECKED_PORT=$(nc -z -v localhost $USER_PORT 2>&1 | grep succeeded | wc -l)
done

#sed -i '/#USER_ACCOUNT/a ,{"listen": "127.0.0.1","port": "'${USER_PORT}'","protocol": "trojan","settings": {"clients": [{"password": "'${USER_ID}'", "email": "'${USER_NAME}'", "level": 0}],"decryption": "none"},"streamSettings": {"network": "ws","security": "none","wsSettings": {"path": "/'${USER_NAME}'","host": ""},"quicSettings": {},"sockopt": {"mark": 0,"tcpFastOpen": true}},"sniffing": {"enabled": true,"destOverride": ["http","tls"]}} # '${USER_NAME}' '${USER_DATE}'' /usr/local/etc/xray/config.json
sed -i '/#USER_ACCOUNT/a ,{"listen": "127.0.0.1","port": "'${USER_PORT}'","protocol": "vmess","settings": {"clients": [{"id": "'${USER_ID}'", "email": "'${USER_NAME}'","alterId": 0,"level": 0}],"decryption": "none"},"streamSettings": {"network": "ws","security": "none","wsSettings": {"path": "/'${USER_NAME}'","host": ""},"quicSettings": {},"sockopt": {"mark": 0,"tcpFastOpen": true}},"sniffing": {"enabled": true,"destOverride": ["http","tls"]}} # '${USER_NAME}' '${USER_DATE}'' /usr/local/etc/xray/config.json

sed -i '/#USER_FRONTEND/a     use_backend websocket_'${USER_NAME}' if { path /'${USER_NAME}' } # '${USER_NAME}' Frontend' /etc/haproxy/haproxy.cfg

sed -i '/#USER_BACKEND/a backend websocket_'${USER_NAME}' # '${USER_NAME}' Backend\n    mode http # '${USER_NAME}' Backend\n    balance roundrobin # '${USER_NAME}' Backend\n    option forwardfor # '${USER_NAME}' Backend\n    timeout tunnel 2h # '${USER_NAME}' Backend\n    server '${USER_NAME}' 127.0.0.1:'${USER_PORT}' check # '${USER_NAME}' Backend' /etc/haproxy/haproxy.cfg

systemctl restart xray
systemctl restart haproxy

echo "1"
