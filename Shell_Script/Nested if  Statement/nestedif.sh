#!/bin/bash
#Purpose: validate and report student subject marks
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #

echo -e "Please Enetr Math marks: \c"
read -r m
echo -e "Please Enetr Physics marks: \c"
read -r p
echo -e "Please Enetr Chemistry marks: \c"
read -r c

if [ $m -ge 35 -a $p -ge 35 -a $c -ge 35]; then
total= `expr $m + $p +$c`
avg=   `expr$total / 3`
echo "Total Marks = $total"
echo "Average Marks = $avg"
    if [ $avg -ge 75 ]; then
    echo "Congratulation, you got Distinction"
    elif [ $avg -ge 60 -a $avg -lt 75]; then
    echo "Congrats you got First Class"
    elif [ $avg -ge 50 -a $avg -lt 60]; then
    echo "you got Second Class"
    elif [ $avg -ge 35 -a $avg -lt 50]; then
    echo "you got Third Class"
    fi
else
echo " Sorry you failed"
fi

# END #
