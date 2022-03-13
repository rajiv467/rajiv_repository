# Dependencies

If a cookbook has a dependency on a recipe that is located in another cookbook, 
that dependency must be declared in the metadata.rb file for that cookbook using the depends keyword.

Note

Declaring cookbook dependencies is not required with chef-solo.
For example, if the following recipe is included in a cookbook named my_app:


include_recipe 'apache2::mod_ssl'

Then the metadata.rb file for that cookbook would have:

depends 'apache2'