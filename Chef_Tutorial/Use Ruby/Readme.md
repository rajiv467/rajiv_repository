
 # Assign a value
A variable uses an equals sign (=) to assign a value.

To assign a value to a variable:

- package_name = 'apache2'

# Use Case Statement
A case statement can be used to compare an expression, and then execute the code that matches.

To select a package name based on platform:

- package 'apache2' do
  case node['platform']
  when 'centos', 'redhat', 'fedora', 'suse'
    package_name 'httpd'
  when 'debian', 'ubuntu'
    package_name 'apache2'
  when 'arch'
    package_name 'apache'
  end
  action :install
end



# Check Conditions

An if expression can be used to check for conditions (true or false).

To check for condition only for Debian and Ubuntu platforms:

- if platform?('debian', 'ubuntu')
  # do something if node['platform'] is debian or ubuntu
else
  # do other stuff
end


# Execute Conditions(Unless)
An unless expression can be used to execute code when a condition returns a false value (effectively, an unless expression is the opposite of an if statement).

To use an expression to execute when a condition returns a false value:

unless node['platform_version'] == '5.0'
  # do stuff on everything but 5.0
end


# Loop over Array
A loop statement is used to execute a block of code one (or more) times. A loop statement is created when .each is added to an expression that defines an array or a hash. An array is an integer-indexed collection of objects. Each element in an array can be associated with and referred to by an index.

To loop over an array of package names by platform:

- ['apache2', 'apache2-mpm'].each do |p|
   package p
  end


# Loop over Hash
A hash is a collection of key-value pairs. Indexing for a hash is done using arbitrary keys of any object (as opposed to the indexing done by an array). The syntax for a hash is: key => "value".

To loop over a hash of gem package names:


{ 'fog' => '0.6.0', 'highline' => '1.6.0' }.each do |g, v|
  gem_package g do
    version v
  end
end


