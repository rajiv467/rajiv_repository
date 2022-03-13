#!/bin/bash
#Purpose: FPrint any given number table usig while loop
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #
echo -e " Please provide one value: \c"
read -r c
i= 1
while [ $i -le 10 ]
do
b= `expr $c \* $i`

echo "$C * $i = $b"
i `expr $i +1`
done

# END #
