# how the shell works
user interface <--> Shell <--> Kernel <--> Hardware

- Means if run the cat command so in bakend command goto kernel then hardware


# creat a 01_file.sh file

1. in this file we are creating a folder (createbyscript)
2. then in folder we create a file (testfile.txt)
3. then use echo command we add some content(Testing file script) in that file


# on terminal use below command  to run the .sh file
 - sh 01_file.sh  

 # test all implemantation 
  ## check the folder(createbyscript)
  - cd createbyscript

  ## check the file
  - ls 

  ## then see the content in file
  - cat testfile.txt

  ## 0utput will be
   Testing file script

 # if we run the same command again  sh 01_file.sh
 - then folder and file we be same but content will append in that file 
