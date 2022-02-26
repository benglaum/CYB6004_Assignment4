#!/bin/bash/python3

from numpy import loadtxt

lines = loadtxt("ProcessedCountryStats.txt", delimiter=";")
for line in lines:
    print(line)
