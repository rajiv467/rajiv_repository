# Use of Include in Chef

- to call recipe from another recipe within same cookbook
- in this process we can run multiple recipe from cookbook



#  see below example

- [] vi test-cookbook/recipes/default.rb
  
   # Now Vi editor will open
    include_recipe "test-cookbook::test-recipe"
    include_recipe "test-cookbook::recipe3"        // so we can add multiple recipe within same cookbook

# run below command

- [] chef-client-zr "recipe[test-cookbook::default]"



# Now we can add multiple recipe from multiple cookbooks
# below is example for this
 - [] vi apache-cookbook/recipes/default.rb
  
   # Now Vi editor will open
    include_recipe "apache-cookbook::apache-recipe"
    include_recipe "apache-cookbook::recipe1" 

- [] chef-client-zr "recipe[test-cookbook::default], recipe[apache-cookbook::default]"
