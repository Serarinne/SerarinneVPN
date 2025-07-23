#!/bin/bash
clear
USER_NAME=$1
USER_DATE=$(grep -E ".*# ${USER_NAME} .*" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 28)
sed -i "/# $USER_NAME $USER_DATE/d" /usr/local/etc/xray/config.json
sed -i "/# $USER_NAME Frontend/d" /etc/haproxy/haproxy.cfg
sed -i "/# $USER_NAME Backend/d" /etc/haproxy/haproxy.cfg
systemctl restart xray
systemctl restart haproxy
