#!/bin/bash

#Colours
R="\033[31m"
G="\033[32m"
Y="\033[33m"
B="\033[34m"
P="\033[35m"
C="\033[36m"
N="\033[0m"

#Variables
SPACE=" "
VERTICAL="|"
BOLD="\e[1m"
ITALIC="\e[3m"
ULINE="\e[4m"
NONE="\e[0m"
PAD48="%+48s"

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

downloadingData() {
    #Creating Text files for data Processing.
    echo "Creating Text file 1" > countryStats.txt
    echo "Creating Text file 2" > ProcessedCountryStats.txt
    printf "Downloading please wait...." 

    #Downloads country information and stores it in a text file
    #wget -q "https://stats.cybergreen.net/country" -O countryStats.txt
        
    #function that does all the pre processing.
    dataEditing countryStats.txt ProcessedCountryStats.txt

    printf "Complete \n"
}

#function AWKRetreve(colour, ) {
#    awk -F ";" '{ printf "$1%s$2\n" " }' ProcessedCountryStats.txt
#}


DisplayMenu() {

	#Displays the menu
    printf "\n$B%s$ULINE%s$NONE$N$B%s\n%s$PAD48\n" " __________________" "Main Menu" "____________________" "|" "|"
    printf "$B%s$P%s$B%s$P%s$B%s\n" "| " "Type " "'download'" " to download the lastest data. " "|" 
    printf "$B%s$P%s$B%s$P%s$B%s\n$B%s$PAD48\n%s" "| " "Type " "'exit'" " to exit." "                          |" "|" "|"
    printf "$B%s$ULINE$P%s$NONE$B%s\n" "| " "Type a number to select a option" "              |"
    printf "$B%s%s$P%s$B%s\n" "| " " 1. " "Compare Countries                         " "|"
    printf "$B%s%s$P%s$B%s\n" "| " " 2. " "Compare Risk                              " "|"
    printf "$B%s%s$P%s$B%s\n" "| " " 3. " "Search for indivdual country              " "|"
    printf "$B%s%s$N\n\n" "|_" "______________________________________________|"  
}

clear

#Runs the password check script.
#./PasswordCheck.sh

#If the password is correct then the if statement is executed.
if [ $? -eq 0 ]; then

    DisplayMenu

	#Loop runs until user selects to exit.
	while [ 1 ]; do

        #Asks the user to select the option.
        read -p $'\e[3mEnter: \e[0m' selection

        case "$selection" in

	    '1') ./SearchCountry.sh; clear; DisplayMenu ;;
	    '2') ./SearchRisk.sh; clear; DisplayMenu ;;
	    '3') ./SearchRank.sh; clear; DisplayMenu ;;
	    '4') ./CompareCountries.sh; clear; DisplayMenu ;;
	    '5') ./OtherOne.sh; clear; DisplayMenu ;;
        "exit") printf "$R%s\n" "Goodbye!"; exit ;;
        "download") downloadingData ;;
        *) printf "$R%s$N\n" "Not a valid option... Please select again" ;;
        esac
            
	done

else
	exit
fi


