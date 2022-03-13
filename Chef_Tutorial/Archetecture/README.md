# Recipes:
- where we write/create code

# Cookbooks
- Collection of recipes

# Cookbook(Chef-server)
- Coonect to Nodes through Bootstrap

# Ohai
- Database of Nodes

# Chef-Client
- Ask to Ohai for current file/status then check in chef-server for updated file

# Idempotency
- take updated code/file only

# to see the list of cookbooks in chef-server
- knife cookbooks list

# to detele the cookbook in chef-server
- knife cookbooks delete <cookbookname> -y

# same for node and role
