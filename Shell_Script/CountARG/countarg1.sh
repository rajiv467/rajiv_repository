#!/bin/bash
#Purpose: to learn Specail varibale? how is help in shell script
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #
#echo "your current given parameter are $#"
if [ $# -lt 1] ; then                           #lt mean less than
echo "Programm usage is './scrriptname.sh' options"

else 
echo "Programm run successfully"
f1


# END #