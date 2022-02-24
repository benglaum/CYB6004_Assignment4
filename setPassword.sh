#!/bin/bash

# Ask user to enter a folder name.
read -p "Type a folder name: " folderName

# Ask user to enter a password.
read  -p "Type a secret password: " -s password

# Checks if the directory already exists before storing the password.
if [ -d "$folderName" ]; then

	# Hashes chosen password before storing it in text file.
	echo "$password" | sha256sum > "$folderName/secret.txt"

# Stores password in current directory.
elif [ -z "$folderName" ]; then
	echo "$password" | sha256sum > "secret.txt"

else
	mkdir "$folderName"
	echo "$password" | sha256sum > "$folderName/secret.txt"
fi

echo " "
