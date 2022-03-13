# raise Keyword
In certain situations it may be useful to stop a Chef Infra Client run entirely by using an unhandled exception. 
The raise keyword can be used to stop a Chef Infra Client run in both the compile and execute phases.

Note

You may also see code that uses the fail keyword, which behaves the same 
but is discouraged and will result in Cookstyle warnings.
Use these keywords in a recipe—but outside of any resource blocks—to trigger an unhandled exception during the compile phase. For example:


file '/tmp/name_of_file' do
  action :create
end

raise "message" if platform?('windows')

package 'name_of_package' do
  action :install
end


where platform?('windows') is the condition that will trigger the unhandled exception.