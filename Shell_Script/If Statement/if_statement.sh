#!/bin/bash
#Purpose: If Statement example
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #

echo "Please provide value below ten: \c"
read -r value

if [ $value -le 10 ]; then                  #must take a space b/w if and [, [ and $value, 10 and ] and ; and then
echo " you provided value is $value"
touch /tmp/test{1..100}.txt
echo "Script complete successfully"

fi

#if value will be less than equal to 10 then it will run the script and create 100 file in /tmp directory
#if value willl be greater than 10 then script will exit

# END #