#!/bin/bash
clear
echo -e "-----------------------------------------"
echo -e "|            Restore Service            |"
echo -e "-----------------------------------------"
echo ""
read -rp "URL Backup: " -e FILE_URL
wget -O /root/backup.zip "$FILE_URL"
unzip /root/backup.zip -d /root
sleep 1
echo -e "Restoring...."
rm -f /usr/local/etc/xray/config.json
rm -f /etc/haproxy/haproxy.cfg
cp /root/serarinne/config.json /usr/local/etc/xray/config.json
cp /root/serarinne/haproxy.cfg /etc/haproxy/haproxy.cfg
rm -f /root/backup.zip
echo ""
echo -e "Restarting Service..."
systemctl restart haproxy
systemctl restart xray
echo ""
read -p "$(echo -e "Back")"
menu