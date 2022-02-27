#!/bin/bash

#Colours
R="\033[31m"
G="\033[32m"
Y="\033[33m"
B="\033[34m"
P="\033[35m"
C="\033[36m"
N="\033[0m"

#Symbols and text formats
SPACE=" "
VERTICAL="|"
BOLD="\e[1m"
ITALIC="\e[3m"
ULINE="\e[4m"
NONE="\e[0m"
PAD48="%+48s"

#Displays the menu 
SearchRiskMenu() {

    printf "$P%s$B$ULINE%s$NONE$P%s\n\n" "  Type a " "country name" " to add it to the table."
    printf "$P%s$B%s$P%s\n\n" "  Type " "'random'" " to add a random country to table."
    printf "$P%s$B%s$P%s\n\n" "  Type " "'view'" " to display the table."
    printf "$P%s$B%s$P%s\n\n" "  Type " "'clear'" " to clear the table."
    printf "$P%s$B%s$P%s\n" "  Type " "'back'" " to go back to the previous menu."
    printf "$B%s\n$N" "--------------------------------------------" 
}

#Displays the countries names that are in the table 
DisplayCountrysMessage() {

    #Check to see if there are countries in the table data text file
    if [ -s TableData.txt ]; then
        printf "%s" "Your Table: "

        #Prints the country names that are in the text file TableData
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

#Checks to see if the file exits and then removes it
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

#Prints the table to the Terminal 
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

#Main program starts here
clear

#Creates empty textfiles
echo -n > TableData.txt
echo -n > CountryLine.txt

#Display the Menu
DisplayCountrysMessage
SearchRiskMenu

#Loop runs until user selects to go back.
while [ 1 ]; do

    #Asks the user to select the option.
    read -p $'\e[3mEnter: \e[0m' SELECTION
    CountryName=$SELECTION

    case $SELECTION in

        #Adds a random Country to the table
	    'random')

            #Generates a random number between 0 and 200
            number=$(shuf -i 0-200 -n1)

            #Retreves the country corresponding to that number and adds it to the table file.
            sed -n $number'p' ProcessedCountryStats.txt >> TableData.txt
            
            #Resets the terminal 
            clear
            DisplayCountrysMessage
            SearchRiskMenu

            #Prints that a country has been added to the table
            printf "  $G%s$N\n\n" " A random country was added to your table!"
            ;;

        #View Table
	    'view')

            #Resets the terminal 
            clear
            DisplayCountrysMessage
            SearchRiskMenu

            #Checks to see if the table file is empty.
            if [ -s TableData.txt ]; then
                
                #Displays the table in the terminal 
                ViewTable

            else
                #Prints an error message that the table is empty
                printf "$R%s$N\n\n" " Error: Your table is empty, please add a country"
            fi
            ;;

        'clear')
            #Deletes all the data in the table file 
            echo -n > TableData.txt 

            #Resets the terminal menus
            clear
            DisplayCountrysMessage
            SearchRiskMenu 
            ;;

        'back') 
            clear
            break
            ;;   
        
        #Checks to see if what was typed in is a valid country
	    *) 
            clear
            DisplayCountrysMessage
            SearchRiskMenu

            #Checks to see if there are any countries by that name in the data.
            awk -v name="$CountryName" -F ";" '{ if ($1 == name) print $0 }' ProcessedCountryStats.txt > CountryLine.txt
            
            #If the file is not empty
            if [ -s CountryLine.txt ]; then
                cat CountryLine.txt >> TableData.txt
                clear
                DisplayCountrysMessage
                SearchRiskMenu
                printf "  $G$CountryName%s$N\n\n" " was added to your table!"
            
            #If the file is empty
            else
                clear
                DisplayCountrysMessage
                SearchRiskMenu
                printf "  $R%s$N\n\n" " Error: No data avaliable on '$CountryName'" 
            fi
            ;;
        esac           
    done

#Deletes the textfiles if they have not been already deleted
cleanUpTxtFiles TableData.txt
cleanUpTxtFiles CountryLine.txt
cleanUpTxtFiles Processing.txt

exit
