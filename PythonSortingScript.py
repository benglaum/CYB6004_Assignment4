#!/bin/bash/Python3

#Creating Variables 
risk_rank = [0,0]
line = 0
dict1={}

#Retreving the risk and rank chosen by the user from the text file
file = open("Processing.txt", "r")
for x in file:
  risk_rank[line] = x
  line = line + 1
file.close()

#Casting the risk and rank into intergers
riskNum = int (risk_rank[0])
rankNum = int (risk_rank[1])
count = 0

#Opening the data file and retrieving columns associated with that risk and rank
file = open("ProcessedCountryStats.txt", "r")
for line in file:

    #splitting the data into a list of items
    content = [line.rsplit(';')]
    country = content[0][0]

    #removing commas inbetween numbers
    riskValue = content[0][riskNum].replace(',','')

    #Removing N/A values 
    if riskValue.isdigit():
        dict1[country] = int (riskValue)
        count = count + 1

file.close()

#Checking to see if the rank number is to high
if (count > rankNum ):

    #Sort the data 
    NewSorted = sorted(dict1, key=dict1.get)

    #retreve the data with the corresponding rank value
    country = NewSorted[(-(rankNum))]

    #Retreve the country name
    amount = dict1.get('country')

    #Write the country name to the text file
    file = open("Processing.txt", "w")
    file.write(country)
    file.close()

else:
    #Empty the text file
    file = open("Processing.txt", "w")
    for line in file:
        file.write("")
    file.close()
    