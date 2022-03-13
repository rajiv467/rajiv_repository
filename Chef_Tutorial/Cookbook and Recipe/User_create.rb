
# Create a user

User "rajiv" do
    action :create
end



# Now run the below command

- [cookbooks] chef-client-zr "recipe[test-cookbooks::user_create]"

