#!/bin/bash

# Ask user to enter the password.
read -p "Enter the secret password: " -s password

# Retrieves the stored password for file.
storedPassword=$(cat secret.txt)

# Hashes the entered password.
entredPassword=$(echo "$password" | sha256sum)

# Checks if the entered password maches the stored password.
if [ "$entredPassword" == "$storedPassword" ]; then
	echo -e "\n\e[33m  Access Granted \e[0m"
	exit 0
else
	echo -e "\n\e[31m  Access Denied \e[0m"
	exit 1
fi
