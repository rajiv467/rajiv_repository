#Use  Data Bags
Data bags store global variables as JSON data.
Data bags are indexed for searching and can be loaded by a cookbook or accessed during a search.

The contents of a data bag can be loaded into a recipe. 
For example, a data bag named apps and a data bag item named my_app:


{
  "id": "my_app",
  "repository": "git://github.com/company/my_app.git"
}
can be accessed in a recipe, like this:


- my_bag = data_bag_item('apps', 'my_app')
The data bag item’s keys and values can be accessed with a Hash:

- my_bag['repository'] #=> 'git://github.com/company/my_app.git'