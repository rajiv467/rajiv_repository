- create Linux M/c
- login as ec2-user
   sudo su
   yum update -y

# Now goto google search
 - www.chef.io    
  go to Download--> Chef Workstation
  Enter your datails--> automatically downlaod(Stop it)
  - Goto local download & copy url

- Now goto Linux m/c
  - [ec2-iser]# wget  <pasteurl>
  - [ec2-iser]# ls     // will show the package in output
  - [ec2-iser]# yum install <chef-package> -y
  - [ec2-iser]# which chef      
  - [ec2-iser]# chef --version      // check the version
  - [ec2-iser]# mkdir cookbooks     // name shoulb be same as cookbooks
  - [ec2-iser]# cd cookbooks
  - [cookbooks]# chef generate cookbook test-cookbook     // create a new cookbook test-cookbook
  - [cookbooks]# yum install tree -y     // insatll tree package
  - [cookbooks]# cd test-cookbook
  - [test-cookbook]# chef generate recipe test-recipe
  - [test-cookbook]# cd ..
  - [cookbooks]# vi test-cookbook/recipes/test-recipe.rb


    # new  vi editor will open
     file "/myfile" do
     content "this is testing code"
     action :create
     end

  - [cookbooks]# chef exec ruby -c test-cookbook/recipes/test-recipe.rb     // syntax ok in output
  - [cookbooks]# chef-client-zr "recipe[test-cookbooks::test-recipe]"      //zr means local m/c run  



  - [ec2-iser]# cd cookbooks
  - [cookbooks]# chef generate cookbook apache-cookbook     // create a new cookbook apache-cookbook
  - [cookbooks]# cd apache-cookbook
  - [test-cookbook]# chef generate recipe apache-recipe
  - [test-cookbook]# cd ..
  - [cookbooks]# vi apache-cookbook/recipes/apache-recipe.rb
    

    # new  vi editor will open
     Package "httpd" do
    action :install
    end
 
    file "/var/www/httpd/index.html" do
    content "this is an apache server"
    action :create
    end

    service "httpd"  do
    action [ :enable, :start]
    end    
   
  - [cookbooks]# chef exec ruby -c apache-cookbook/recipes/apache-recipe.rb     // syntax ok in output
  - [cookbooks]# chef-client-zr "recipe[apache-cookbooks::apache-recipe]"      //zr means local m/c run  

