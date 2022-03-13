  #!/bin/bash
  #Purpose: Verifying differnce b/w quotaion marks
  #Version: 1.0
  #Created Date   Thu May 3 11:33:24  IST 2022
  #Modified date:
  #Athore: Rajiv Gupta
  # START #
  VAR1 = 12345
  TEST = TechAr
  # Double Quotes
  echo "Execute double quotes $VAR1 $TEST"    #Double quotes will take value from variable

  # Single Quotes
  echo 'Execute single quotes $VAR1 $TEST'   #Single Quotes will take the same output as we take in this command


  # Reverse Quotes
  echo "This Hostname is `hostname`"      #it will run as double quotes does and we pass the command like 'hostname' , 'cal'
  
  # END #