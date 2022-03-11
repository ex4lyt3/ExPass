#!/bin/bash

mainDir=~/test/.expass

#Check if files exist
if [ -d $mainDir ] && [ -f $mainDir/data ]  && [ -f $mainDir/verify_key ];
then
    read -p "WARNING: The essential directories have been set up. Do you want to set ExPass up again? All essential directories and data will be wiped. [Y/N] " resetInput
    resetInput=${resetInput^^}
    echo $resetInput
    if [[ $resetInput == "Y" ]] 
    then
        echo "All essential directories and data will be wiped."
    else
        echo "Exit"
        exit
    fi
fi

echo "Setting up ExPass"
echo "..."

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
openssl enc -nosalt -aes-256-cbc -pbkdf2 -k $masterpassword -P | md5sum > $mainDir/verify_key
masterpassword="" #I DONT KNOW

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
