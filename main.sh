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

#Sed function to replace text
sedFormating() {
    sed -i "s%$1%$2%g" $3
}

#Checks to see if the file exits and then removes it
cleanUpTxtFiles() {
    if [ -f $1 ]; then
        rm $1
    fi
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

#Download the data form the web page and preprocess it into a useful form
downloadingData() {
    #Creating Text files for data Processing.
    echo "Creating Text file 1" > countryStats.txt
    echo "Creating Text file 2" > ProcessedCountryStats.txt
    printf "Downloading please wait...." 

    #Downloads country information and stores it in a text file
    wget -q "https://stats.cybergreen.net/country" -O countryStats.txt
        
    #function that does all the pre processing.
    dataEditing countryStats.txt ProcessedCountryStats.txt
    printf "Complete \n"
}

#Displays the main menu 
DisplayMenu() {

    printf "$NONE%s\n" "Welcome to the program"
    
    #Top Border and heading
    printf "$BOLD$B%s$NONE\n"  "-----------------------------------------------------------------------------------------"   
    printf "$B%s\n" "  Main Menu" 
    printf "$BOLD$B%s$NONE\n"  "  -----------------------------------------------------------------------------------" 

    #Menu options
    printf "$P%s$B%s$P%s\n\n" "  Type " "'download'" " to download the lastest data."
    printf "$P%s$B%s$P%s\n\n"  "  Type " "'exit'" " to exit."     
    printf "$P%s$B%s$P%s\n\n" "  Type" " '1' " "to compare different countries on their amount of vunerable open devices."
    printf "$P%s$B%s$P%s\n" "  Type" " '2' " "to look up how different countries rank based on the type of risk."

    #Bottom Border
    printf "$BOLD$B%s$NONE\n\n"  "-----------------------------------------------------------------------------------------" 
}


#Main program Starts here
clear

#Runs the password check script
./PasswordCheck.sh

#If the password is correct then the if statement is executed.
if [ $? -eq 0 ]; then

    DisplayMenu

	#Loop runs until user selects to exit.
	while [ 1 ]; do

        #Asks the user to select the option.
        read -p $'\e[3mEnter: \e[0m' SELECTION
        item=$SELECTION

        case $SELECTION in

	    '1') 
            #Check to see if the text file exits
            if [ -f ProcessedCountryStats.txt ]; then
                #Runs search country script
                ./SearchCountry.sh
                clear
                DisplayMenu
            
            else
                clear
                DisplayMenu
                #Prints error to download the data
                printf "$R%s$N\n\n" "  Error: No data. Please type 'download' to download the data." 
            fi
            ;;

	    '2') 
            #Check to see if the text file exits
            if [ -f ProcessedCountryStats.txt ]; then
                #Runs search rank script
                ./SearchRank.sh
                clear
                DisplayMenu

            else
                clear
                DisplayMenu
                #Prints error to download the data
                printf "$R%s$N\n\n" "  Error: No data. Please type 'download' to download the data." 
            fi
            ;;

        "exit")
            #Prints Goodbye messarge 
            printf "\n$R%s\n" "  Goodbye!";
            
            #Deleates text files 
            cleanUpTxtFiles countryStats.txt
            cleanUpTxtFiles ProcessedCountryStats.txt
            exit 
            ;;

        "download")
            #Downloads the data and preprocesses it 
            downloadingData 
            ;;

        #For all other options not above
        *) 
            clear
            DisplayMenu
            #Prints not a valid choice
            printf "$R%s$N\n\n" "  Error: '$item' is not a valid choice." 
            ;;
        esac    
	done
else
	exit
fi