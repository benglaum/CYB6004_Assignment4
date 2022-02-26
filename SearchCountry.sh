#!/bin/bash

sedFormating() {
    sed -i "s%$1%$2%g" $3
}

SearchRiskMenu() {

    printf "$P%s\n" "Type a number to select a option"
    printf "$P%s\n" " 1. Add country to table"
    printf "$P%s\n" " 2. Add random country to table"
    printf "$P%s\n" " 3. View table"
    printf "$P%s\n" " 4. Clear table"
    printf "$P%s\n" " 5. Back"
    printf "$B%s\n" "---------------------------------" 
}

AddCounty(){
    print "Hello"
}

DeleteCountry(){
    print "Hello"
}

CreateTable(){
    print "Hello"
}

DisplayCountrysMessage() {

    if [ -s TableData.txt ]; then
        printf "%s\n" "The following countries are in your table: "
        awk -F ";" '{if ($1 != "") printf "(%s) ", $1}' TableData.txt
        printf " \n"

    else
    printf "%s\n" "----------------------------------------------"
    printf "%s\n" "There are currently 0 countries in your table."
    fi

    printf "%s\n" "----------------------------------------------" 
}

clear
echo -n > TableData.txt
echo -n > CountryLine.txt

#Display the Menu
DisplayCountrysMessage
SearchRiskMenu


 #sedFormating ';' '\n' CountryLine.txt


#Loop runs until user selects to go back.
while [ 1 ]; do

    #Asks the user to select the option.
    read -p $'\e[3mEnter number from above: \e[0m' selection

    case "$selection" in

        #Adds a Country to the table
	    '1') clear; DisplayCountrysMessage; SearchRiskMenu

        read -p $'\e[3m Type a Country Name: \e[0m' CountryName

        awk -v name="$CountryName" -F ";" '{ if ($1 == name) print $0 }' ProcessedCountryStats.txt > CountryLine.txt
            
        #if the file is not empty
        if [ -s CountryLine.txt ]; then
            cat CountryLine.txt >> TableData.txt
            clear
            DisplayCountrysMessage
            SearchRiskMenu
            printf "  $CountryName$R%s%s$N\n\n" " was added to your table!"
            
        #if the file is empty
        else
            clear
            DisplayCountrysMessage
            SearchRiskMenu
            printf "  $R%s$N\n\n" " Error... No data avaliable."
        fi
        ;;

        #Adds a random Country to the table
	    '2') ;;

        #View Table
	    '3') clear 
        
        ;;

        '4')  
        echo -n > TableData.txt 
        clear; DisplayCountrysMessage; SearchRiskMenu 
        ;;

        '5') clear; exit ;;   
        
        *) clear; DisplayCountrysMessage; SearchRiskMenu 
        printf "  $R%s$N\n\n" " Error... Not a valid option" 
        ;;
        
    esac
            
done

exit

#awk -F ";" '{ print $1}' ProcessedCountryStats.txt
#awk '{split($0, array, ":"); print array[2]}'
#awk '/;/, /;/ {printf "$s\n" $1}' ProcessedCountryStats.txt
