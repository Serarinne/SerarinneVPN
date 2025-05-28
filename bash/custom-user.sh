#!/bin/bash
clear
SERVER_BUG=$(cat /root/serarinne/bug)
SERVER_CF=$(cat /root/serarinne/cloudflare)
SERVER_NAME=$(cat /root/serarinne/name)
SERVER_IP=$(cat /root/serarinne/ip)

echo ""
echo -e "-----------------------------------------"
echo -e "|                Add User               |"
echo -e "-----------------------------------------"
until [[ $USER_NAME =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
    read -rp "Username: " -e USER_NAME
    CLIENT_EXISTS=$(grep -w $USER_NAME /usr/local/etc/xray/config.json | wc -l)
    
    if [[ ${CLIENT_EXISTS} == '1' ]]; then
        clear
        echo ""
        echo "Username already used"
        echo ""
        read -n 1 -s -r -p "Back"
        menu
    fi
done

read -rp "Active for: " -e ACTIVE_PERIOD
read -rp "UUID: " -e USER_ID
USER_DOMAIN="${USER_NAME}.${SERVER_CF}"
USER_DATE=`date -d "$ACTIVE_PERIOD days" +"%d-%m-%Y"`
USER_PORT=10000

until [[ ${CHECKED_PORT} == '0' ]]; do
    ((USER_PORT++))
    CHECKED_PORT=$(nc -z -v localhost $USER_PORT 2>&1 | grep succeeded | wc -l)
done

curl --location 'https://api.cloudflare.com/client/v4/zones/6a5a22da00ad10ab2fbcb32c969872e1/dns_records' > /dev/null 2>&1 \
--header 'Content-Type: application/json' \
--header 'X-Auth-Email: serarinne@gmail.com' \
--header 'X-Auth-Key: 5a1eca87cd911e698afe5538150e969f39feb' \
--data '{
      "content": "'${SERVER_IP}'",
      "name": "'${USER_DOMAIN}'",
      "proxied": false,
      "type": "A"
    }'

sed -i '/#USER_ACCOUNT/a ,{"listen": "127.0.0.1","port": "'${USER_PORT}'","protocol": "trojan","settings": {"clients": [{"password": "'${USER_ID}'", "email": "'${USER_NAME}'", "level": 0}],"decryption": "none"},"streamSettings": {"network": "ws","security": "none","wsSettings": {"path": "/'${USER_NAME}'","host": ""},"quicSettings": {},"sockopt": {"mark": 0,"tcpFastOpen": true}},"sniffing": {"enabled": true,"destOverride": ["http","tls"]}} # '${USER_NAME}' '${USER_DATE}'' /usr/local/etc/xray/config.json

sed -i '/#USER_FRONTEND/a     use_backend websocket_'${USER_NAME}' if { path /'${USER_NAME}' } # '${USER_NAME}' Frontend' /etc/haproxy/haproxy.cfg

sed -i '/#USER_BACKEND/a backend websocket_'${USER_NAME}' # '${USER_NAME}' Backend\n    mode http # '${USER_NAME}' Backend\n    balance roundrobin # '${USER_NAME}' Backend\n    option forwardfor # '${USER_NAME}' Backend\n    timeout tunnel 2h # '${USER_NAME}' Backend\n    server '${USER_NAME}' 127.0.0.1:'${USER_PORT}' check # '${USER_NAME}' Backend' /etc/haproxy/haproxy.cfg

ACCOUNT_URL="trojan://${USER_ID}@${SERVER_BUG}:80?type=ws&host=${USER_DOMAIN}&headerType=none&path=%252F${USER_NAME}&security=none#${SERVER_NAME} ${USER_NAME} ${USER_DATE}"

systemctl restart xray
systemctl restart haproxy

echo $ACCOUNT_URL
echo -e ""
read -p "$(echo -e "Back")"
menu
