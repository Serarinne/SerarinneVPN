#!/bin/bash
timedatectl set-timezone Asia/Jakarta
export SERVER_SCRIPT="https://raw.githubusercontent.com/Serarinne/SerarinneVPN/main"
export SERVER_IP=$(wget -qO- ipv4.icanhazip.com)

clear
echo -e "-----------------------------------------"
echo -e "|             Setup Server              |"
echo -e "-----------------------------------------"
echo -e ""
read -rp "Server Name        : " SERVER_NAME
read -rp "Server Domain      : " SERVER_DOMAIN
read -rp "Bug Domain         : " SERVER_BUG
read -rp "Cloudflare Domain  : " SERVER_CF
mkdir /root/serarinne
rm -f /root/serarinne/name
rm -f /root/serarinne/domain
rm -f /root/serarinne/bug
rm -f /root/serarinne/cloudflare
rm -f /root/serarinne/ip
echo $SERVER_NAME > /root/serarinne/name
echo $SERVER_DOMAIN > /root/serarinne/domain
echo $SERVER_BUG > /root/serarinne/bug
echo $SERVER_CF > /root/serarinne/cloudflare
echo $SERVER_IP > /root/serarinne/ip

clear
echo -e "-----------------------------------------"
echo -e "|           Instalasi Package           |"
echo -e "-----------------------------------------"
apt install curl wget nano vnstat iftop htop zip unzip jq net-tools -y
#Ubuntu
#apt install --no-install-recommends software-properties-common
#add-apt-repository ppa:vbernat/haproxy-3.1

#Debian
curl https://haproxy.debian.net/haproxy-archive-keyring.gpg > /usr/share/keyrings/haproxy-archive-keyring.gpg
echo deb "[signed-by=/usr/share/keyrings/haproxy-archive-keyring.gpg]" http://haproxy.debian.net bookworm-backports-3.2 main > /etc/apt/sources.list.d/haproxy.list
apt update
apt install haproxy=3.2.\* -y
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

mkdir /root/serarinne
rm -f /usr/local/etc/xray/config.json
wget -O /usr/local/etc/xray/config.json "${SERVER_SCRIPT}/configuration/xray.cfg"
ln -s /usr/local/etc/xray/config.json /root/serarinne/config.json
rm -f /etc/haproxy/haproxy.cfg
wget -O /etc/haproxy/haproxy.cfg "${SERVER_SCRIPT}/configuration/haproxy.cfg"
ln -s /etc/haproxy/haproxy.cfg /root/serarinne/haproxy.cfg

systemctl daemon-reload
systemctl restart xray
systemctl restart haproxy
systemctl restart vnstat

clear
echo -e "-----------------------------------------"
echo -e "|            Instalasi Addon            |"
echo -e "-----------------------------------------"
wget -O /usr/bin/add-user "${SERVER_SCRIPT}/bash/add-user.sh" && chmod +x /usr/bin/add-user
wget -O /usr/bin/auto-delete-user "${SERVER_SCRIPT}/bash/auto-delete-user.sh" && chmod +x /usr/bin/auto-delete-user
wget -O /usr/bin/backup-server "${SERVER_SCRIPT}/bash/backup-server.sh" && chmod +x /usr/bin/backup-server
wget -O /usr/bin/change-domain "${SERVER_SCRIPT}/bash/change-domain.sh" && chmod +x /usr/bin/change-domain
wget -O /usr/bin/change-name "${SERVER_SCRIPT}/bash/change-name.sh" && chmod +x /usr/bin/change-name
wget -O /usr/bin/custom-user "${SERVER_SCRIPT}/bash/custom-user.sh" && chmod +x /usr/bin/custom-user
wget -O /usr/bin/delete-user "${SERVER_SCRIPT}/bash/delete-user.sh" && chmod +x /usr/bin/delete-user
wget -O /usr/bin/extend-user "${SERVER_SCRIPT}/bash/extend-user.sh" && chmod +x /usr/bin/extend-user
wget -O /usr/bin/limit-speed "${SERVER_SCRIPT}/bash/limit-speed.sh" && chmod +x /usr/bin/limit-speed
wget -O /usr/bin/limitless-speed "${SERVER_SCRIPT}/bash/limitless-speed.sh" && chmod +x /usr/bin/limitless-speed
wget -O /usr/bin/menu "${SERVER_SCRIPT}/bash/menu.sh" && chmod +x /usr/bin/menu
wget -O /usr/bin/restart-service "${SERVER_SCRIPT}/bash/restart-service.sh" && chmod +x /usr/bin/restart-service
wget -O /usr/bin/restore-server "${SERVER_SCRIPT}/bash/restore-server.sh" && chmod +x /usr/bin/restore-server
wget -O /usr/bin/system-bandwidth "${SERVER_SCRIPT}/bash/system-bandwidth.sh" && chmod +x /usr/bin/system-bandwidth
wget -O /usr/bin/user-bandwidth "${SERVER_SCRIPT}/bash/user-bandwidth.sh" && chmod +x /usr/bin/user-bandwidth
wget -O /usr/bin/user-login "${SERVER_SCRIPT}/bash/user-login.sh" && chmod +x /usr/bin/user-login
wget -O /usr/bin/user-usage "${SERVER_SCRIPT}/bash/user-usage.sh" && chmod +x /usr/bin/user-usage
wget -O /usr/bin/bot-user-list "${SERVER_SCRIPT}/bash/bot-user-list.sh" && chmod +x /usr/bin/bot-user-list
wget -O /usr/bin/bot-add-user "${SERVER_SCRIPT}/bash/bot-add-user.sh" && chmod +x /usr/bin/bot-add-user

echo "#59 23 * * * root auto-delete-user" >> /etc/crontab
echo "1 0 * * * root rm -f /root/serarinne/user-usage" >> /etc/crontab
echo "#5 0 * * * root limitless-speed" >> /etc/crontab
echo "0 1 * * * root backup-server" >> /etc/crontab
echo "0 */1 * * * root user-usage" >> /etc/crontab
echo "#0 5 * * * root limit-speed" >> /etc/crontab
echo "#0 10 * * * root limit-speed" >> /etc/crontab
echo "#0 15 * * * root limit-speed" >> /etc/crontab
echo "#0 20 * * * root limit-speed" >> /etc/crontab

apt autoclean -y
echo "menu" >> /root/.profile
rm /root/install.sh
reboot
