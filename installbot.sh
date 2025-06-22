#!/bin/bash
export SERVER_SCRIPT="https://raw.githubusercontent.com/Serarinne/SerarinneVPN/main"
export SERVER_IP=$(cat /root/serarinne/ip)
clear
echo -e "-----------------------------------------"
echo -e "|              Setup Bot                |"
echo -e "-----------------------------------------"
echo -e ""
read -rp "WHAPI TOKEN : " WHAPI_TOKEN

rm -rf /root/serarinne/bot
mkdir /root/serarinne/bot
wget -O /root/serarinne/bot/index.py "${SERVER_SCRIPT}/bot/index.py" && chmod +x /root/serarinne/bot/index.py

apt install python3 python3-pip python3-flask python3-full -y
pip install --break-system-packages Flask
pip install --break-system-packages requests
pip install --break-system-packages jsonify
pip install --break-system-packages requests-toolbelt
pip install --break-system-packages python-dotenv
pip install --break-system-packages spur

cat > /root/serarinne/bot/.env <<-END
TOKEN=${WHAPI_TOKEN}
API_URL=https://gate.whapi.cloud
BOT_URL=http://${SERVER_IP}:5000/hook
IPSVR=${SERVER_IP}
PORT=5000
END

cat > /etc/systemd/system/panelbot.service <<-END
[Unit]
Description=Bot WA

[Service]
ExecStart=nohup python3 /root/serarinne/bot/index.py &
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
END

chmod +x /etc/systemd/system/panelbot.service
systemctl enable panelbot.service
systemctl start panelbot.service
systemctl restart panelbot.service
rm -f /root/installbot.sh

echo "0 1 * * * root systemctl restart panelbot.service" >> /etc/crontab
