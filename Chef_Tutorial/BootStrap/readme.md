# BootStrap

# // step given Below
- create account in chef-server
- then attach workstation to chef-server
- now uplaod the cookbooks from workstation to chef-server
- now attached the nodes to chef-server via bootstrap
- apply cookbooks from chef-server to nodes


# // lab
- go to google and search manage.checf.io--> create one account
- goto chef account--> click on organisation--> starter kit--> downlaod starter kit
- open downlaod content unzip--> chef-repo
- now download winscp-->login with ec2 credential--> drap and drop the  chef-repo folder in linux m/c
- now open workstation 
- [ec2-user] ls     
 // o/p  chef-repo    cookbooks 
- [ec2-user] cd chef-repo
- [chef-repo]  ls -a     
 // o/p  .chef    cookbooks   roles 
 - [chef-repo]  cd .chef/
 - [.chef] ls
   // o/p  config.rb      <*.pem>    
   # config.rb---url
   # *.pem---- organistion which we create in chef-server
 - [.chef] cd ..
 - [chef-repo]  knife ssl chef    //for checking wprk station is connected to chef-server
   // o/p successfully verfied certificate from ...................
