#!/bin/bash
clear
echo -e "-----------------------------------------"
echo -e "|        System Bandwidth Usage         |"
echo -e "-----------------------------------------"
echo ""
echo -e " 1   Hourly Usage"
echo -e " 2   Daily Usage"
echo -e " 3   Monthly Usage"
echo -e " 4   Current Usage"
echo -e " 0   Menu"
echo -e ""
read -p " Select From Options [1-5] :  " options

case $options in
1)
clear
echo -e "-----------------------------------------"
echo -e "|        Hourly Bandwidth Usage         |"
echo -e "-----------------------------------------"
echo ""
vnstat -h
echo -e ""
;;

2)
clear
echo -e "-----------------------------------------"
echo -e "|         Daily Bandwidth Usage         |"
echo -e "-----------------------------------------"
echo ""
echo -e ""
vnstat -d
echo -e ""
;;

3)
clear
echo -e "-----------------------------------------"
echo -e "|       Monthly Bandwidth Usage         |"
echo -e "-----------------------------------------"
echo ""
echo -e ""
vnstat -m
echo -e ""
;;

4)
clear
echo -e "-----------------------------------------"
echo -e "|         Live Bandwidth Usage          |"
echo -e "-----------------------------------------"
echo ""
echo -e ""
vnstat -l
echo -e ""
;;

0)
menu
;;

*)
echo -e "Incorrect Number!"
;;
esac
read -p "$(echo -e "Back")"
system-bandwidth