#!/bin/bash
export SERVER_IP=$(wget -qO- ipv4.icanhazip.com)

clear
echo ""
echo -e "-----------------------------------------"
echo -e "|             Change Domain             |"
echo -e "-----------------------------------------"
echo ""
read -rp "New Domain: " SERVER_DOMAIN
rm -f /root/serarinne/domain
echo $SERVER_DOMAIN > /root/serarinne/domain
read -rp "Bug Domain: " SERVER_BUG
rm -f /root/serarinne/bug
echo $SERVER_BUG > /root/serarinne/bug
read -rp "Cloudflare Domain: " SERVER_CF
rm -f /root/serarinne/cloudflare
echo $SERVER_CF > /root/serarinne/cloudflare
rm -f /root/serarinne/ip
echo $SERVER_IP > /root/serarinne/ip
sleep 1
clear
echo ""
read -p "$(echo -e "Back")"
menu