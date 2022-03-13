create a template for run the script and add some value in the file


# Run following command in terminal

- chmod 777 template
- sudo mv template /bin
- template   
   # then it will ask 
   Please provide filename you want to create:  variable   
   # type the filename so variable.sh file will create
- cat helloworld.sh
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


- after variable.sh file creation we will use the variable

so modified the variable.sh file

# and then Run the below command

- sh variable.sh

get the below output 

"Variable A value: 10
"Variable BA value: 23
"Variable BA value: 45
"Variable HOSTNAME value: techar
"Variable DATE value: date will show            
"Wrong Variable value:       #in output command not found
"False @ value: var            #in output command not found
"hyphen-a variable value: a   #in output command not found

