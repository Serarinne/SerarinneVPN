#!/bin/bash
clear
export SERVER_SCRIPT="https://raw.githubusercontent.com/Serarinne/SerarinneVPN/main"

mkdir /root/serarinne/bot
wget -O /root/serarinne/bot/index.py "${SERVER_SCRIPT}/bot/index.py" && chmod +x /root/serarinne/bot/index.py
wget -O /root/serarinne/bot/requirements.txt "${SERVER_SCRIPT}/bot/requirements.txt" && chmod +x /root/serarinne/bot/requirements.txt
wget -O /root/serarinne/bot/.env "${SERVER_SCRIPT}/bot/.env" && chmod +x /root/serarinne/bot/.env

apt install python3-pip
pip install Flask
pip install requests
pip install jsonify
pip install requests-toolbelt
pip install python-dotenv
pip install spur

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
