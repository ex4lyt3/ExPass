#!/bin/bash

echo "Setting up ExPass"
echo "..."

trap CleanUp 1 2 3 6 14 15 SIGTSTP

mainDir=~/test/.expass 

CleanUp()
{
    rm -rf $mainDir 
    echo "Keyboard interrupt; directory for ExPass's data has been deleted (${mainDir}"
    exit
}

mkdir $mainDir
chmod 700 $mainDir
chmod +t $mainDir

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
masterPassword2=""

touch $mainDir/password
echo "Lorem Ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem Ipsum dolor" >> $mainDir/password
#encrypt file with password