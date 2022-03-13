# Runlist 
- runlist is use for run the recipe in sequence order  that we mention in run list
- with this process we can add multiple recipe in one command but must be one recipe from one cookbook


# Run the below command for Multiple Recipes using run list

- [] chef-client-zr "recipe[test-cookbook::test-recipe], recipe[apache-cookbook::apache-recipe]"
