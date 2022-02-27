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

SearchRiskMenu() {

    printf "$P%s$B$ULINE%s$NONE$P%s\n\n" "  Type a " "country name" " to add it to the table."
    printf "$P%s$B%s$P%s\n\n" "  Type " "'random'" " to add a random country to table."
    printf "$P%s$B%s$P%s\n\n" "  Type " "'view'" " to display the table."
    printf "$P%s$B%s$P%s\n\n" "  Type " "'clear'" " to clear the table."
    printf "$P%s$B%s$P%s\n" "  Type " "'back'" " to go back to the previous menu."
    printf "$B%s\n$N" "--------------------------------------------" 
}

DisplayCountrysMessage() {

    if [ -s TableData.txt ]; then
        printf "%s" "Your Table: "
        awk -F ";" '{if ($1 != "") printf "(%s) ", $1}' TableData.txt
        printf " \n"

    else
    
    printf "%s\n" "There are currently 0 countries in your table."
    fi

    printf "$B%s\n" "----------------------------------------------" 
}

#Function to print an Underline of a certain Length.
UnderLine() {
	string=$(printf "%0.s_" $(seq 1 $1))
	printf "$string"
}

cleanUpTxtFiles() {
    if [ -f $1 ]; then
        rm $1
    fi
}

#Function to print whole line for the table.
WholeLine() {
	printf "$1"
	UnderLine 32
	printf "$1"
	UnderLine 20
	printf "$1"
	UnderLine 12
	printf "$1"
	UnderLine 12
	printf "$1"
	UnderLine 12
    printf "$1"
	UnderLine 14
	printf "$1"
	UnderLine 14
	printf "$1\n"
}

ViewTable() {
    echo -n > CountryLine.txt

    #Prints top vertical Line of table
    WholeLine "$SPACE"

    #print Headings
    printf "| $B%-30s$N | $B%-18s$N | $B%-10s$N | $B%-10s$N | $B%-10s$N | $B%-12s$N | $B%-12s$N |\n" "Country" "Open Recurive DNS" "Open NTP" "Open SNMP" "Open SSDP" "Open Chargen" "DDOS Rank"
    
    #Prints Vertical line of table with `|`
    WholeLine "$VERTICAL"

    #Prints the filtered results.
    awk -F";" '{printf "| %-30s | %-18s | %-10s | %-10s | %-10s | %-12s | %-12s |\n", $1, $4, $7, $10, $13, $16 , $21}' TableData.txt

    #Prints Bottom line of table.
    WholeLine "$VERTICAL"

    printf " \n"
}

clear
echo -n > TableData.txt
echo -n > CountryLine.txt

#Display the Menu
DisplayCountrysMessage
SearchRiskMenu

#Loop runs until user selects to go back.
while [ 1 ]; do

    #Asks the user to select the option.
    read -p $'\e[3mEnter: \e[0m' selection

    CountryName=$selection

    case "$selection" in

        #Adds a random Country to the table
	    'random') 
        number=$(shuf -i 0-50 -n1)
        sed -n $number'p' ProcessedCountryStats.txt >> TableData.txt
        clear
        DisplayCountrysMessage
        SearchRiskMenu
        printf "  $G%s$N\n\n" " A random country was added to your table!"
        ;;

        #View Table
	    'view') clear; DisplayCountrysMessage; SearchRiskMenu

        if [ -s TableData.txt ]; then
            ViewTable
        else
            printf "$R%s$N\n\n" " Error: Your table is empty, please add a country"
        fi
        ;;

        'clear') echo -n > TableData.txt 
        clear; DisplayCountrysMessage; SearchRiskMenu 
        ;;

        'back') clear; break ;;   
        
        #Adds a Country to the table
	    *) clear; DisplayCountrysMessage; SearchRiskMenu

        awk -v name="$CountryName" -F ";" '{ if ($1 == name) print $0 }' ProcessedCountryStats.txt > CountryLine.txt
            
        #if the file is not empty
        if [ -s CountryLine.txt ]; then
            cat CountryLine.txt >> TableData.txt
            clear
            DisplayCountrysMessage
            SearchRiskMenu
            printf "  $G$CountryName%s$N\n\n" " was added to your table!"
            
        #if the file is empty
        else
            clear
            DisplayCountrysMessage
            SearchRiskMenu
            printf "  $R%s$N\n\n" " Error: No data avaliable on '$CountryName'" 
        fi
        ;;
    esac           
done

cleanUpTxtFiles TableData.txt
cleanUpTxtFiles CountryLine.txt
cleanUpTxtFiles Processing.txt

exit

