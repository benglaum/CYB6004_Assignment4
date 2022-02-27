#!/bin/bash/Python3
import sys

risk_rank = [0,0]
line = 0
dict1={}

file = open("Processing.txt", "r")
for x in file:
  risk_rank[line] = x
  line = line + 1
file.close()

riskNum = int (risk_rank[0])
rankNum = int (risk_rank[1])
count = 0

file = open("ProcessedCountryStats.txt", "r")
for line in file:
    content = [line.rsplit(';')]
    country = content[0][0]
    riskValue = content[0][riskNum].replace(',','')
    if riskValue.isdigit():
        dict1[country] = int (riskValue)
        count = count + 1
file.close()

if (count > rankNum ):
    NewSorted = sorted(dict1, key=dict1.get)
    country = NewSorted[(-(rankNum))]
    amount = dict1.get('country')

    file = open("Processing.txt", "w")
    file.write(country)
    
    file.close()

else:
    file = open("Processing.txt", "w")
    for line in file:
        file.write("")
    file.close()



