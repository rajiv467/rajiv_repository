#!/bin/bash
#Purpose: FPrint any given number table usig while loop
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #
for i in `cat hostfile`
do
ping -c 1 $i
valid= `echo $?`
if [ $valid -gt 1 ]; then
echo "$i Host is not Reachable"
else 
echo "$i Host is up"
fi
done


# for -i in 1 2 3 4 5
# do 
# echo "$i "

# END #