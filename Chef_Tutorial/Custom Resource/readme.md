Syntax
The layout for a custom resource is:


provides :resource_name

property :property_name, RubyType, default: 'value'

action :action_a do
 # a mix of built-in Chef Infra resources and Ruby
end

action :action_b do
 # a mix of built-in Chef Infra resources and Ruby
end
The first action listed is the default action.

# Write a Custom Resource
You’ll write the code for a custom resource in a Ruby file and located in a cookbook’s /resources directory (you need to generate the resource first). This code:

Declares the properties of the custom resource
Loads current state of properties for existing resources
Defines each action the custom resource may take
Generate a Custom Resource
The resources directory does not exist by default in a cookbook. Generate the resources directory and a resource file from the chef-repo/cookbooks directory with the command:


- chef generate resource PATH_TO_COOKBOOK RESOURCE_NAME

# For example, this command generates a site resource in the custom_web cookbook:
- chef generate resource cookbooks/custom_web site


## The custom_web cookbook directory with a custom resource has the structure:
├ cookbooks
 ├ custom_web
   ├ recipes
   | └ default.rb
   ├ resources
   | └ site.rb
   ├ test
   | └ integration
   | | └ default
   | | | └ default_test.rb
   ├ .gitignore
   ├ CHANGELOG.md
   ├ chefignore
   ├ kitchen.yml
   ├ LICENSE
   ├ metadata.rb
   ├ Policyfile.rb
   └ README.md

Example Resource
This example site uses Chef Infra’s built-in file, service and package resources, and includes :create and :delete actions. It also assumes the existence of a custom httpd template. The code in this custom resource is similar to a typical recipe because it uses built-in Chef Infra Client resources, with the addition of the property and actions definitions for this custom resource.


provides :site

property :homepage, String, default: '<h1>Hello world!</h1>'

action :create do
  package 'httpd'

  service 'httpd' do
    action [:enable, :start]
  end

  file '/var/www/html/index.html' do
    content new_resource.homepage
  end
end

action :delete do
  package 'httpd' do
    action :remove
  end

  file '/var/www/html/index.html' do
    action :delete
  end
end
where

//
site is the name of the custom resource. The provides statement makes the custom resource available for use recipes.
homepage sets the default HTML for the index.html file with a default value of '<h1>Hello world!</h1>'
the action block uses the built-in collection of resources to tell Chef Infra Client how to install Apache, start the service, and then create the contents of the file located at /var/www/html/index.html
action :create is the default resource (because it is listed first); action :delete must be called specifically (because it is not the default action)
Once written, you can use a custom resource may be used in a recipe with the same syntax as Chef Infra Client built-in resources.//
