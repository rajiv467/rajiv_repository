# Create group

group "dev" do
    action :create
    member 'gupta'
    append true    // add member with privious one or append with privious one
end



# Now run following command

- [cookbooks] chef-client-zr "recipe[test-cookbook::group_create]"

# check if user and group are create are not

- [] cat /etc/group    //will show the outpur of all users and groups

