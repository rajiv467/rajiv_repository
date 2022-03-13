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

echo "a+b value is $(($a+$b))"
echo "a-b value is $(($a-$b))"
echo "axb value is $(($a*$b))"
echo "a/b value is $(($a/$b))"
echo "a%b value is $(($a%$b))"

# echo "a+b value is `expr $a + $B` "
# echo "a-b value is `expr $a - $B`"
# echo "axb value is `expr $a \* $B`"
# echo "a/b value is `expr $a / $B`"
# echo "a%b value is `expr $a % $B`"

echo "complete successfully"

# END #