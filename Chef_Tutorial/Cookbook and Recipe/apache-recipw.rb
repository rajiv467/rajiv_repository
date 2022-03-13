Package "httpd" do
action :install
end

file "/var/www/httpd/index.html" do
content "this is an apache server"
action :create
end

service "httpd"  do
action [ :enable, :start]
end    
