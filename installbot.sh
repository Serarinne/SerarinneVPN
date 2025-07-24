#!/bin/bash
export SERVER_SCRIPT="https://raw.githubusercontent.com/Serarinne/SerarinneVPN/main"
export SERVER_IP=$(cat /root/serarinne/ip)
clear
echo -e "-----------------------------------------"
echo -e "|              Setup Bot                |"
echo -e "-----------------------------------------"
echo -e ""
read -rp "WHAPI TOKEN : " WHAPI_TOKEN

wget -O /usr/bin/bot-add-user "${SERVER_SCRIPT}/bash/bot-add-user.sh" && chmod +x /usr/bin/bot-add-user
wget -O /usr/bin/bot-delete-user "${SERVER_SCRIPT}/bash/bot-delete-user.sh" && chmod +x /usr/bin/bot-delete-user

rm -f /root/installbot.sh
