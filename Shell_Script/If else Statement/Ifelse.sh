#!/bin/bash
#Purpose: If else Statement example
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #

echo "Please any value: \c"
read -r a
echo "Please any value: \c"
read -r -b

if [ $a -ge $b ]
then
echo " $a is greater than $b"
else
echo " $b is greater than $a"
fi


# END #