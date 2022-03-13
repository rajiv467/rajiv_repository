#!/bin/bash
#Purpose: Find biggest number amoung  four digits
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #

echo "Please enter a value: \c"
read -r a
echo "Please enter b value: \c"
read -r b
echo "Please enter c value: \c"
read -r C
echo "Please enter d value: \c"
read -r d

if [ $a -gt $b -a $a -gt $c -a $a -gt $d ]; then
echo "$a is the biggest number"

elif [ $b -gt $c -a $b -gt $d]; then
echo "$b is big"

elif [ $c -gt $d ]; then
echo " $c is big"

else 
echo "$d is big"
fi

# END #
