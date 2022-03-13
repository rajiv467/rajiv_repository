# count the paramete we provide while running the command

- sh countarg.sh  rajiv gupta shell scripting tutorial


- so output will
your current given parameter are 5


# count the file in current directory
- sh countarg.sh *

output will be

your current given parameter are 5     # count the file in current directory

  ## if we add new file and again run the command
   touch test.txt
   - sh countarg.sh *

   Now output will be
   your current given parameter are 6

# if we check and want to  count the file for differnt directoty  
- sh countarg.sh /etc/*

output will be

your current given parameter are 145     # count the file in etc  directory


# in countarg1.sh file 
 we only defind that how we run the command

 - if we do not use the prper command like below we get the error
 sh countarg1.sh 

 - if we use proper command to run then successfuly run like below
 sh countarg1.sh /etc/* 
   



