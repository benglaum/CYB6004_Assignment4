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
PAD10="%+10s"

sedFormating() {
    sed -i "s%$1%$2%g" $3
}

cleanUpTxtFiles() {
    if [ -f $1 ]; then
        rm $1
    fi
}

SearchMenu() {
    printf "$BOLD$B%s$N$NONE\n"  "-------------------------------------------------------" 
    printf "%s$NONE%s$N\n"  "  " "Adding a country to the table:"
    printf "$G%s$B%s$G%s\n" "    First Type a " "Risk Number" " from options below:"

    printf "$B%s$P%s\n" "       1. " "# of Vulnerable Open Recursive DNS Devices."
    printf "$B%s$P%s\n" "       2. " "# of Vulnerable Open NTP Devices."
    printf "$B%s$P%s\n" "       3. " "# of Vulnerable Open SNMP Devices."
    printf "$B%s$P%s\n" "       4. " "# of Vulnerable Open SSDP Devices."
    printf "$B%s$P%s\n" "       5. " "# of Vulnerable Open CHARGEN Devices."
    printf "$B%s$P%s\n" "       6. " "DDOS Rank"

    printf "$G%s$B%s$G%s\n\n" "    Second Type a " "Rank Number" " between 1 and 200"
    
    printf "$P%s$B%s$P%s\n" "  Type " "'view'" " to view the table."
    printf "$P%s$B%s$P%s\n" "  Type " "'clear'" " to clear the table."
    printf "$P%s$B%s$P%s\n" "  Type " "'back'" " to go back to the previous menu."
    printf "$BOLD$B%s$N$NONE\n"  "-------------------------------------------------------"
}

DisplayCountrysMessage() {

    if [ -s TableData.txt ]; then
        printf "%s" "Your Table: "
        awk -F ";" '{if ($1 != "") printf "(%s) ", $1}' TableData.txt
        printf " \n"

    else
    
    printf "%s\n" "There are currently 0 countries in your table."
    fi
}

#Function to print an Underline of a certain Length.
UnderLine() {
	string=$(printf "%0.s_" $(seq 1 $1))
	printf "$string"
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

rankProcessing() {
    clear; DisplayCountrysMessage; SearchMenu
    risk=$1
    name=$2

    while [ 1 ]; do

        printf "$NONE$G%s$NONE\n" "   Risk Selected: ($name)"
        read -p $'\e[3mNow enter a rank: \e[0m' selection
        rank=$selection
        
        case "$selection" in

            'view')  clear; DisplayCountrysMessage; SearchMenu; ViewTable ;;

            'clear') echo -n > TableData.txt 
            clear; DisplayCountrysMessage; SearchRankMenu ;;

            'back') clear; DisplayCountrysMessage; SearchMenu; 
            printf "$R%s$NONE\n" "  Enter 'back' again to go back to the main menu."
            break ;;

            *) 
            #Runs a python sorting script
            echo -n > Processing.txt
            echo $risk > Processing.txt
            echo $rank >> Processing.txt

            python PythonSortingScript.py

            if [ -s Processing.txt ]; then
                cName=$(cat Processing.txt)
                awk -v name="$cName" -F ";" '{ if ($1 == name) print $0 }' ProcessedCountryStats.txt > CountryLine.txt
                cat CountryLine.txt >> TableData.txt
                clear
                DisplayCountrysMessage
                SearchMenu
               
                printf "  $R$cName%s$N\n" " was added to your table!"
                break

            else
                clear; DisplayCountrysMessage; SearchMenu
                printf "  $R%s%s%s$N\n" " Error:" "'$rank' is too large!" " Don't have data on that many countries." 
            fi
            ;;
        esac
    done
}


clear
echo -n > TableData.txt
echo -n > CountryLine.txt
echo -n > Processing.txt

#Display the Menu
DisplayCountrysMessage
SearchMenu

#Loop runs until user selects to go back.
while [ 1 ]; do

    #Asks the user to select the option.
    read -p $'\e[3mEnter a risk number: \e[0m' selection
    risk=$selection

    case "$selection" in

        'view') clear; DisplayCountrysMessage; SearchMenu; ViewTable ;;

        'clear') echo -n > TableData.txt 
        clear; DisplayCountrysMessage; SearchMenu ;;

        'back') clear; break ;;
        '1') rankProcessing 3 'Vulnerable Open Recursive DNS Devices';;
        '2') rankProcessing 6 'Vulnerable Open NTP Devices';;
        '3') rankProcessing 9 'Vulnerable Open SNMP Devices';;
        '4') rankProcessing 12 'Vulnerable Open SSDP Devices';;
        '5') rankProcessing 15 'Open CHARGEN Devices';;
        '6') rankProcessing 20 'DDOS Rank';;   
        
	    *) clear; DisplayCountrysMessage; SearchMenu;
        printf "  $R%s$N\n" " Error: '$risk' is not a valid option."
        
    esac
done
cleanUpTxtFiles TableData.txt
cleanUpTxtFiles CountryLine.txt
cleanUpTxtFiles Processing.txt
exit