#!/bin/bash

mainDir=~/test/.expass

#Check if files exist
if [ -d $mainDir ] && [ -d $mainDir/data ]  && [ -f $mainDir/verify_key ];
then
    read -p "WARNING: The essential directories have been set up. Do you want to set ExPass up again? All essential directories and data will be wiped. [Y/N] " resetInput
    resetInput=${resetInput^^}
    echo $resetInput
    if [[ $resetInput == "Y" ]] 
    then
        echo "All essential directories and data will be wiped."
        rm -rf $mainDir 
    else
        echo "Exit"
        exit
    fi
fi

echo "Setting up ExPass"
echo "..."

#Check if openssl, shasum is installed
trap CleanUp 1 2 3 6 14 15 SIGTSTP 

CleanUp()
{
    rm -rf $mainDir 
    echo "Keyboard interrupt; the directory for ExPass's data has been deleted (${mainDir})"
    exit
}

mkdir $mainDir
chmod 700 $mainDir
chmod +t $mainDir
mkdir $mainDir/data
chmod 700 $mainDir/data
chmod +t $mainDir/data
touch $mainDir/data/index
touch $mainDir/data/index.txt.enc

echo "The directory for ExPass's data has been set up in ${mainDir}"

read -sp "Please enter your master password: " masterpassword
read -sp "Re-enter your master password: " masterpassword2

masterPasswordCheck()
{
    if [[ $masterpassword == $masterpassword2 ]]; 
    then
        echo "Master password confirmed"
    else
        read -sp "Re-enter your master password: " masterpassword2
        masterPasswordCheck
    fi
}

masterPasswordCheck
masterpassword2="" #i dont know

#Verify the key
openssl enc -nosalt -aes-256-cbc -pbkdf2 -k $masterpassword -P | shasum -a 512 > $mainDir/verify_key
key=$(openssl enc -nosalt -aes-256-cbc -pbkdf2 -k $masterpassword -P | grep "key")
iv=$(openssl enc -nosalt -aes-256-cbc -pbkdf2 -k $masterpassword -P | grep "iv")
echo "Password index" > $mainDir/data/index
openssl enc -e -nosalt -aes-256-cbc -pbkdf2 -in $mainDir/data/index -out $mainDir/data/index.enc -base64 -K "${key:4:64}" -iv "${iv:4:32}" #returns an error if you do not quote the env variables
masterpassword=""

#copy main file
cp ../expass $mainDir/expass
chmod +x $mainDir 

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
 \\▓▓▓▓▓▓▓▓\\▓▓   \\▓▓\\▓▓       \\▓▓▓▓▓▓▓\▓▓▓▓▓▓▓ \\▓▓▓▓▓▓▓"  #unnecessary 
echo "UNPROFESSIONALLY DEVELOPED / USE AT YOUR OWN RISK!!!"
