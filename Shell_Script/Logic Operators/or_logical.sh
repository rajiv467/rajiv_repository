#!/bin/bash
#Purpose: to learn logical operator? how it help in shell script
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #

# OR operator example
echo "Enter First Numeric value: \c"
read -r t
echo "Enter Second Numeric value: \c"
read -r b

if [ $t -le 20 -o $b -ge 30 ]; 
#if [[$1 -le 20 || $2 -ge 30]]
then
echo "Statement is True"
else
echo "False, Statement Try Again "

fi

# END $