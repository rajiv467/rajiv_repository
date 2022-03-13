# Below are some Specail Variable

$* , $#, $1, $2, $0, "$@", $?, $$ and $! 

create a template for run the script and add some value in the file


# Run following command in terminal

- chmod 777 template
- sudo mv template /bin
- template   
   # then it will ask 
   Please provide filename you want to create:  specail_variable   
   # type the filename so specail_variable.sh file will create
- cat specail_varible.sh
  # so all contect will here  as we added in template file like below
  #!/bin/bash
  #Purpose:
  #Version:
  #Created Date   Thu May 3 11:33:24  IST 2022
  #Modified date:
  #Athore: Rajiv Gupta
  # START #

  # END #

 So this is sample .sh template file created and can modified as per requirement


- after variable.sh file creation we will use the special variable

so modified the specail_variable.sh file

# and then Run the below command

- sh specail_variable.sh rajiv gupta is a good boy

get the below output 

rajiv gupta is a good boy               #store the parametes in single string
'6' output is 6                          # count the argument number
'rajiv & gupta' output  rajiv and gupta"     #show 1st and 2nd  positional parameter respectively
'rajiv gupta is a good boy' output of rajiv gupta is a good boy"  # take all argument as separate argument
'0' output is 0"                                #status value will displayed if successsfuly run the output "0"
'2018' output is 2018"                              #show the pid(process id to distribute) 
'2019' output is 2019"                                 #will show the pid of last execution job
'specail_variable.sh' output is specail_variable.sh"           # will show the shell script you are running

