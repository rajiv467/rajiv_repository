#  Bootstrap A Node
-- Attaching a anode to chef-server called Bootstrap
-- Now all command will run inside chef-repo folder


# Steps given below

- create one linus m/c (Node1) in same AZ's with following advanced details
    #! bin/bash
    sudo su
    yum update -y

- now goto chef- workstatation
- [chef-repo] knife bootstrap <private ip of node1> --ssh-user ec2-user -sudo -i <pemkey of node1> -N node1

# transfer the .pem key from local system to workstaion in chef-repo folder using winscp  

- [chef-repo] knife node list   // to see bootstrapped node

- [chef-repo] cd ..
- [ec-user] mv cookbooks/test-cookbook  chef-repo/cookbooks
- [ec-user] mv cookbooks/apache-cookbook  chef-repo/cookbooks
- [ec2-user] rm -rf cookbooks
- [ec2-user] cd chef-repo

# now upload the  cookbooks into chef-server
- [chef-repo] knife cookbooks upload apache-cookbook
- [chef-repo] knife cookbook list     // check cookbook uplaod or not

# Now we attached the recipe which we would like to run on node1
- [chef-repo] knife node run list set node1 "recipe[test-cookbook::test-recipe]"
- [chef-repo] knife node run list set node1 "recipe[apache-cookbook::apache-recipe]"

- [chef-repo] knife node show node1     //will show the runlist or all recipe 


## now take acces of Node1
- [] sudo su
- [] chef-client

- now using chef-client all file will be upadted and then goto browser and paste the ipnof node1 you will see the webpage


## for testing
- [chef-repo] vi cookbooks/apache-cookbook/recipe/apache-recipe.rb

- do some changes in content
- [chef-repo] knife cookbook uplaod apache-cookbook

- now again open node1 and run chef-client command and then  open the browser and see upadated content 


# For Automation do following step
- goto node1
- vi /etc/crontab       // add below content in crontab file so that we do not need to run chef-client commnad  everytime on node
  * * * * * root chef-client

- goto workstation
- [chef-repe] vi cookbooks/apache-cookbook/recipe/apache-recipe.rb
- do some changes in file
- [chef-repo] knife cookbook uplaod apache-cookbook
-  open browser and paste public ip , you will see upadted content



## Example with 2 node
# step
- create one node2 in aws with advanced details
  #! bin/bash
  sudo su
  yum update -y
  echo "* * * * * root chef-client" >> /etc/crontab

- goto workstation and run bootstrap command
[chef-repo] knife bootstrap <private ip of node2 --ssh-user ec2-user -sudo -i <pemkey of node2> -N node1

- now attached cookbook to node2 runlist
- [chef-repo] knife node run list set node2 "recipe[test-cookbook::test-recipe]"

- now open browser and see the content
