#!/bin/bash
export SERVER_IP=$(wget -qO- ipv4.icanhazip.com)

clear
echo ""
echo -e "-----------------------------------------"
echo -e "|          Change Server Name           |"
echo -e "-----------------------------------------"
echo ""
read -rp "New Server Name: " SERVER_NAME
rm -f /root/serarinne/name
rm -f /root/serarinne/ip
echo $SERVER_NAME > /root/serarinne/name
echo $SERVER_IP > /root/serarinne/ip
sleep 1
clear
echo ""
read -p "$(echo -e "Back")"
menu