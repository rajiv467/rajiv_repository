#!/bin/bash
#Purpose: to learn Specail varibale? how is help in shell script
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #
echo  -e "Please enter some value: \c"
read -r a       # value stored in "a"
echo  -e "Please enter another value: \c"
read -r b       # value store in "b"

test $a -lt $b; echo "$?";        #output value will come in 0 or 1   if true then 0 else 1


# END #
