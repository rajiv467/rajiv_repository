# use of Roles in Chef

# Lab
- [chef-repo] ls
 // o/p .chef  roles  cookbooks

- [chef-repo]  cd roles
- [roles] starter.rb

- [roles] vi devops.rb

 # vi editor will open
 name "devops" 
 descriptio "web server role"
 run list "recipe[apache-cookbook::apache-recipe]"   // can add multiple cookbooks
:wq

- [roles] cd ..

# now upload the roles on chef-server
- [chef-repo] knife roles file from role roles/devops.rb
  // o/p upadated role devops



# below is example for testing
- create two linus m/c
 
- [chef-repo] knife bootstrap <Priavte ip of node1> --ssh-user ec2-user -sudo -i <.pem key of node1> -N node1  // do same for node2

 # connect these nodes to role
- [chef-repo] knife node run_list set node1 "role(devops)   // do same for node2

# now upload the cookbooks
- [chef-repo] knife cookbook upload apache-cookbook

- check browser and see the content

  # if need to add/modify the role then uplaod the role and after that uplaod the cookbooks 



