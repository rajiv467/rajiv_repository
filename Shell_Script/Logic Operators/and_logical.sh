#!/bin/bash
#Purpose: to learn logical operator? how it help in shell script
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #

# AND operator example
echo "Enter your Maths Subject Marks: \c"
read -r m
echo "Enter your Physics Subject Marks: \c"
read -r p
echo "Enter your Chemistry Subject Marks: \c"
read -r c


if test $m -ge 35 -a $p -ge 35 $c -ge 35        #"-a" is use for AND
then
echo "Congratulation, you have passed in all subject"
else
echo "Sorry you not upto mark in one of the subject"
fi



# END #