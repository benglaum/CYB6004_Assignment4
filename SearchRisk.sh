#!/bin/bash

SearchRiskMenu() {
    printf "\n$B%s\n\n" "Search risk"
    printf "$P%s\n" "1. Add country to table"
    printf "$P%s\n" "2. Delete country from table"
    printf "$P%s\n" "3. Clear table"
    printf "$P%s\n" "4. Back"
    printf "\n$B%s\n" "______" 
}

SearchRiskMenu

#awk -F ";" '{ printf "$s" $1}' ProcessedCountryStats.txt
#awk '{split($0, array, ":"); print array[2]}'
#awk '/;/, /;/ {printf "$s\n" $1}' ProcessedCountryStats.txt


read -p $'\e[3mEnter: \e[0m' selection


