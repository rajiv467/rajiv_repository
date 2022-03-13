#!/bin/bash
#Purpose: FPrint any given number table usig while loop
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #
echo -c "Enter a number: \c"
read -r a
echo -c "Enter b number: \c"
read -r b

echo "1. sum of value"
echo "2. Subtraction"
echo "3. Multipication"
echo "4. Division"
echo "5. Modulo Division"
echo -c " Enter your choice from above menu: \c"
read -r c
case $ch in
1) echo "Sum of $a + $b = "`expr $a + $b`;;
2) echo "Substarction  = "`expr $a - $b`;;
3) echo "Multipication = "`expr $a \* $b`;;
4) echo "Division = "`expr $a / $b`;;
5) echo "Modulo Divison = "`expr $a % $b`;;
*) echo "Invalid option  Provided"
esac 