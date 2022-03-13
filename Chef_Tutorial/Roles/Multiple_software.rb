%w (httpd mariadb-server winzip git) .each do |P|
    package P do
        action :install
    end
end
