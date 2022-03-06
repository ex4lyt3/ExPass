#!/bin/bash

echo "Setting up ExPass"
echo "..."

trap CleanUp 1 2 3 6 14 15 SIGTSTP

mainDir=~/test/.expass 

CleanUp()
{
    rm -rf $mainDir 
    echo "Keyboard interrupt; the directory for ExPass's data has been deleted (${mainDir}"
    exit
}

mkdir $mainDir
chmod 700 $mainDir
chmod +t $mainDir
mkdir $mainDir/data

echo "The directory for ExPass's data has been set up in ${mainDir}"

read -sp "Please enter your master password: " masterpassword
read -sp "Re-enter your master password: " masterpassword2

masterPasswordCheck(){
    if [[ "$masterpassword" == "$masterpassword2" ]] 
    then
        echo "Master password confirmed"
    else
        read -sp "Re-enter your master password: " masterpassword2
        masterPasswordCheck
    fi
}

masterPasswordCheck
masterpassword2="" #i dont know

touch $mainDir/verify_key

#Verify the key
openssl enc -nosalt -aes-256-cbc -pbkdf2 -k $masterpassword -P | md5sum
masterpassword="" #I DONT KNOW

echo "Set up complete"
sleep 3
echo " ________          _______ 
|        \\        |       \\
| ▓▓▓▓▓▓▓▓__    __| ▓▓▓▓▓▓▓\\ ______   _______  _______
| ▓▓__   |  \\  /  \\ ▓▓__/ ▓▓|      \ /       \/       \\
| ▓▓  \\   \\▓▓\/  ▓▓ ▓▓    ▓▓ \\▓▓▓▓▓▓\  ▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓
| ▓▓▓▓▓    >▓▓  ▓▓| ▓▓▓▓▓▓▓ /      ▓▓\▓▓    \\ \\▓▓    \\
| ▓▓_____ /  ▓▓▓▓\\| ▓▓     |  ▓▓▓▓▓▓▓_\▓▓▓▓▓▓\\_\\▓▓▓▓▓▓\\
| ▓▓     \\  ▓▓ \\▓▓\\ ▓▓      \\▓▓    ▓▓       ▓▓       ▓▓
 \\▓▓▓▓▓▓▓▓\\▓▓   \\▓▓\\▓▓       \\▓▓▓▓▓▓▓\▓▓▓▓▓▓▓ \\▓▓▓▓▓▓▓"