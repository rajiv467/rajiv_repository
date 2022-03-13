#!/bin/bash
#Purpose: to learn Specail varibale? how is help in shell script
#Version: 1.0
#Created Date   Thu May 3 11:33:24  IST 2022
#Modified date:
#Athore: Rajiv Gupta
# START #
echo "'$*' output is $*"     #store the parametes in single string
echo "'$#' output is $#"        # count the argument number
echo "'$1 & $2' output  $1 and $2"  #show 1st and 2nd  positional parameter respectively
echo "'$@' output of $@"          # take all argument as separate argument
echo "'$?' output is $?"        #status value will displayed if successsfuly run the output "0"
echo "'$$' output is $$"        #show the pid(process id to distribute) 
echo "'$!' output is $!"        #will show the pid of last execution job
echo "'$0' output is $0"           # will show the shell script you are running

#END