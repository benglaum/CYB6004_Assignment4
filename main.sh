#!/bin/bash

#Colours
R="\033[31m"
G="\033[32m"
Y="\033[33m"
B="\033[34m"
P="\033[35m"
N="\033[0m"

#Variables
SPACE=" "
VERTICAL="|"

sedFormating() {
    sed -i "s%$1%$2%g" $3
}

dataEditing() {
    #Remove all the lines that don't contain the information.
    awk '(/data-place/ || /data-score/ || (/style=/ && /align=/)) {print $0}' $1 > $2

    #Remove all white space from front from each line.
    sedFormating '^[ \t]*' '' $2

    #Turn into a string to remove new lines.
    string=$(cat $2)

    #Add a new line so that each country is on a new line.
    echo $string | awk '{gsub(/\<tr data-place="/,"\n")}1' > $2

    #Getting to the correct formating.
    sedFormating '"> <td class="score" title="' ';' $2
    sedFormating '" data-score="' ';' $2
    sedFormating '" > <span align="right" style="padding-right:15px">' ';' $2
    sedFormating '</span> <td class="score" title="' ';' $2
    sedFormating '"> <span align="right" style="padding-right:15px">' ';' $2
    sedFormating '</span> <' '' $2
    sed -i '1d' $2
}

#Runs the password check script.
#./PasswordCheck.sh



#If the password is correct then the if statement is executed.
if [ $? -eq 0 ]; then

	#Loop runs until user selects to exit.
	while [ 1 ]; do

	    #Displays the menu
        printf "\n$B%s$N\n\n" "Main Menu"
        printf "$P%s$B%s$P%s$N\n\n" "Type " "'download'" " to download the lastest data."
        printf "$P%s$B%s$P%s$N\n\n" "Type " "'exit'" " to exit."
        printf "$P%s$N\n" "Type a number to investigate a Risk."
        printf "    $B%s$P%s$N \n" "1. " "Open Recursive DNS"
        printf "    $B%s$P%s$N\n" "2. " "Open NTP"
        printf "    $B%s$P%s$N\n" "3. " "Open SNMP"
        printf "    $B%s$P%s$N\n" "4. " "Open SSDP"
        printf "    $B%s$P%s$N\n" "5. " "Open Chargen"
        printf "    $B%s$P%s$N\n\n" "6. " "DDOS"

        #Asks the user to select the option.
        read -p $'\e[34mEnter: \e[0m' selection

        case "$selection" in

	    "1") printf "1\n" ;;
	    "2") printf "2\n" ;;
	    "3") printf "3\n" ;;
	    "4") printf "4\n" ;;
	    "5") printf "5\n" ;;
	    "6") printf "6\n" ;;
        "exit") exit ;;
        "download")
        printf "DOWNLOAD.." 
        #Downloads country information and stores it in a text file
        #wget -q "https://stats.cybergreen.net/country" -O countryStats.txt
        
        #function that does all the pre processing.
        dataEdit countryStats.txt next.txt
        ;;
        
        esac
            printf "$R%s$N\n" "Not a valid option"
	done

else
	exit
fi


