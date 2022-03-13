# node.run_state
Use node.run_state to stash transient data during a Chef Infra Client run. 
This data may be passed between resources, and then evaluated during the execution phase. 
run_state is an empty Hash that is always discarded at the end of a Chef Infra Client run.

For example, the following recipe will install the Apache web server, 
randomly choose PHP or Perl as the scripting language, and then install that scripting language:


package 'httpd' do
  action :install
end

ruby_block 'randomly_choose_language' do
  block do
    if Random.rand > 0.5
      node.run_state['scripting_language'] = 'php'
    else
      node.run_state['scripting_language'] = 'perl'
    end
  end
end

package 'scripting_language' do
  package_name lazy { node.run_state['scripting_language'] }
  action :install
end




where:

The ruby_block resource declares a block of Ruby code that is run during the execution phase of a Chef Infra Client run
The if statement randomly chooses PHP or Perl,
saving the choice to node.run_state['scripting_language']
When the package resource has to install the package for the scripting language, 
it looks up the scripting language and uses the one defined in node.run_state['scripting_language']
lazy {} ensures that the package resource evaluates this during the execution phase of a Chef Infra Client run (as opposed to during the compile phase)