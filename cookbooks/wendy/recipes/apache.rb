#
# Cookbook Name:: wendy
# Recipe:: apache
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apache2::default'
include_recipe 'apache2::mod_ssl'

# web_app node['apache']['test']['server_name'] do
#   template 'web_app.conf.erb'
#   cookbook 'apache2'

#   server_name node['apache']['test']['server_name']
#   server_port '443'
#   docroot node['apache']['test']['docroot']
# end

web_app "test" do
  server_name 'localhost'
  docroot '/var/www/html'
  cookbook 'apache2'
end

firewall_rule 'http/https' do
  protocol :tcp
  port     [80, 443]
#  notifies :enable, 'firewall[default]'
end



  # * directory[/var/lock/apache2] action create
  #   - change owner from 'www-data' to 'root'
