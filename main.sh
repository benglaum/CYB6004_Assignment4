#!/bin/bash

#Colours
R="\033[1;31m"
G="\033[1;32m"
Y="\033[1;33m"
B="\033[1;34m"
P="\033[1;35m"
N="\033[0m"

#Variables
SPACE=" "
VERTICAL="|"

#Downloads country information and stores it in a text file
#wget -q "https://stats.cybergreen.net/country" -O countryStats.txt

#Runs the password check script.
#./PasswordCheck.sh

#If the password is correct then the if statement is executed.
if [ $? -eq 0 ]; then

	#Loop runs until user selects to exit.
	while [ 1 ]; do

	    #Displays the menu
        printf "$R%s$N\n" "Risks"
        printf "%s\n" "1. Open Recursive DNS"
        printf "%s\n" "2. Open NTP"
        printf "%s\n" "3. Open SNMP"
        printf "%s\n" "4. Open SSDP"
        printf "%s\n" "5. Open Chargen"
        printf "%s\n" "6. DDOS"
        printf "%s\n" "7. Exit"

        #Asks the user to select the option.
        read -p $'\e[33mSelect the number: \e[0m' selection

        case "$selection" in

	    "1") printf "1\n" ;;
	    "2") printf "2\n" ;;
	    "3") printf "3\n" ;;
	    "4") printf "4\n" ;;
	    "5") printf "5\n" ;;
	    "6") printf "6\n" ;;
        "7") exit ;;
        "exit") exit ;;

        esac
            printf "$R%s$N\n" "Not a valid option"
	done

else
	exit
fi
