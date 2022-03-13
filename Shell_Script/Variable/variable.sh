#!/bin/bash
#Purpose: What are varibale? how is help in shell script
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #
A=10 
Ba=23
BA=45
HOSTNAME=$(hostname)
DATE= `date`
1value=333
False@var=False
Hyphen-a=WrongValue

echo "Variable A value: $A"
echo "Variable BA value: $Ba"
echo "Variable BA value: $BA"
echo "Variable HOSTNAME value: $HOSTNAME"
echo "Variable DATE value: $DATE"               
echo "Wrong Variable value: $1value"      #in output command not found
echo "False @ value: $False@var"            #in output command not found
echo "hyphen-a variable value: $Hyphen-a"   #in output command not found

#END