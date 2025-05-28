#!/bin/bash
clear
echo -e "-----------------------------------------"
echo -e "|            Restart Service            |"
echo -e "-----------------------------------------"
echo ""
echo -e "Restart Cron"
systemctl restart cron
echo -e "Restart HAProxy"
systemctl restart haproxy
echo -e "Restart XRay-Core"
systemctl restart xray
echo -e ""
read -p "$(echo -e "Back")"
menu