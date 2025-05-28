#!/bin/bash
clear
CURRENT_DATE=$(date +"%Y-%m-%d-%H:%M:%S")
SERVER_NAME=$(cat /root/serarinne/name)

echo -e "-----------------------------------------"
echo -e "|             Backup Server             |"
echo -e "-----------------------------------------"
echo ""
echo -e "Processing backup..."
sleep 1
rm -f /root/serarinne/config.json
rm -f /root/serarinne/haproxy.cfg
cp /usr/local/etc/xray/config.json /root/serarinne/config.json
cp /etc/haproxy/haproxy.cfg /root/serarinne/haproxy.cfg
zip -r $SERVER_NAME-$CURRENT_DATE.zip /root/serarinne > /dev/null 2>&1

curl --write-out %{http_code} --silent --output /dev/null --request PUT --url https://storage.bunnycdn.com/serafile/vpn/${SERVER_NAME}-${CURRENT_DATE}.zip --header 'AccessKey: 2e63f1d0-89f4-48b8-809ff7f8abbb-1847-410a' --header 'Content-Type: application/octet-stream' --header 'accept: application/json' --data-binary @"/root/${SERVER_NAME}-${CURRENT_DATE}.zip"

rm -r /root/${SERVER_NAME}-${CURRENT_DATE}.zip
echo ""
read -p "$(echo -e "Back")"
menu
