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
PAD10="%+10s"

#Checks to see if the file exits and then removes it
cleanUpTxtFiles() {
    if [ -f $1 ]; then
        rm $1
    fi
}

#Created the main menu for this script
SearchMenu() {

    printf "$BOLD$B%s$N$NONE\n"  "-------------------------------------------------------" 
    printf "%s$NONE%s$N\n"  "  " "Adding a country to the table:"
    printf "$G%s$B%s$G%s\n" "    First Type a " "Risk Number" " from options below:"

    #Prints the choices of risks
    printf "$B%s$P%s\n" "       1. " "# of Vulnerable Open Recursive DNS Devices."
    printf "$B%s$P%s\n" "       2. " "# of Vulnerable Open NTP Devices."
    printf "$B%s$P%s\n" "       3. " "# of Vulnerable Open SNMP Devices."
    printf "$B%s$P%s\n" "       4. " "# of Vulnerable Open SSDP Devices."
    printf "$B%s$P%s\n" "       5. " "# of Vulnerable Open CHARGEN Devices."
    printf "$B%s$P%s\n" "       6. " "DDOS Rank"
    
    #Prints the rest of the options: view, back and clear
    printf "$G%s$B%s$G%s\n\n" "    Second Type a " "Rank Number" " between 1 and 200"
    printf "$P%s$B%s$P%s\n" "  Type " "'view'" " to view the table."
    printf "$P%s$B%s$P%s\n" "  Type " "'clear'" " to clear the table."
    printf "$P%s$B%s$P%s\n" "  Type " "'back'" " to go back to the previous menu."
    printf "$BOLD$B%s$N$NONE\n"  "-------------------------------------------------------"
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

#Function for processing the rank selection
rankProcessing() {
    
    #Resets the terminal
    clear
    DisplayCountrysMessage
    SearchMenu

    #Stores the risk number and the risk name
    risk=$1
    name=$2

    while [ 1 ]; do
        printf "$NONE$G%s$NONE\n" "   Risk Selected: ($name)"

        #Asks User to enter a rank number
        read -p $'\e[3mNow enter a rank: \e[0m' SELECTION
        rank=$SELECTION
        
        case $SELECTION in

            #Displays the table in the terminal
            'view')

                #Resets the terminal display
                clear
                DisplayCountrysMessage
                SearchMenu

                #function that creates and table and populates it
                ViewTable 
                ;;


            'clear')

                #Clears the table data file 
                echo -n > TableData.txt

                #Resets the terminal display 
                clear
                DisplayCountrysMessage
                SearchRankMenu 
                ;;

           'back') 
                clear
                DisplayCountrysMessage
                SearchMenu 
                printf "$R%s$NONE\n" "  Enter 'back' again to go back to the main menu."
                break 
                ;;

            #For all other options not listed above 
            *) 
                #Runs a python sorting script
                echo -n > Processing.txt
                echo $risk > Processing.txt
                echo $rank >> Processing.txt
                
                #The python program
                python PythonSortingScript.py

                #True if the text file is not empty
                if [ -s Processing.txt ]; then

                    #Retreves the country name from the python file 
                    cName=$(cat Processing.txt)

                    #Retrives the all the information about that country
                    awk -v name="$cName" -F ";" '{ if ($1 == name) print $0 }' ProcessedCountryStats.txt > CountryLine.txt
                    
                    #Adds that country to the table
                    cat CountryLine.txt >> TableData.txt
                    
                    #Resets the terminal
                    clear
                    DisplayCountrysMessage
                    SearchMenu
               
                    #Prints that the counntry was added to the table
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

#Main Program Starts Here

clear

#Creates all the text files
echo -n > TableData.txt
echo -n > CountryLine.txt
echo -n > Processing.txt

#Display the Menu
DisplayCountrysMessage
SearchMenu

#Loop runs until user selects to go back.
while [ 1 ]; do

    #Asks the user to select the option.
    read -p $'\e[3mEnter a risk number: \e[0m' SELECTION
    risk=$SELECTION

    case $SELECTION in

        'view') 
            clear
            DisplayCountrysMessage
            SearchMenu
            ViewTable
            ;;

        'clear')
            
            #Clears the data in the table file 
            echo -n > TableData.txt
            
            #resets the terminal
            clear
            DisplayCountrysMessage
            SearchMenu
            ;;

        'back') 
            clear
            break
            ;;

        #Runs if user selects risk 1
        '1') 
            rankProcessing 3 'Vulnerable Open Recursive DNS Devices'
            ;;

        #Runs if user selects risk 2
        '2') 
            rankProcessing 6 'Vulnerable Open NTP Devices'
            ;;
        
        #Runs if user selects risk 3
        '3') 
            rankProcessing 9 'Vulnerable Open SNMP Devices'
            ;;

        #Runs if user selects risk 4
        '4') 
            rankProcessing 12 'Vulnerable Open SSDP Devices'
            ;;

        #Runs if user selects risk 5
        '5') 
            rankProcessing 15 'Open CHARGEN Devices'
            ;;

        #Runs if user selects risk 6
        '6') 
            rankProcessing 20 'DDOS Rank'
            ;;   
        
	    *) 
            clear
            DisplayCountrysMessage
            SearchMenu
            printf "  $R%s$N\n" " Error: '$risk' is not a valid option."
            ;;
    esac
done

#Delete all text files in the script if they still exist
cleanUpTxtFiles TableData.txt
cleanUpTxtFiles CountryLine.txt
cleanUpTxtFiles Processing.txt
exit