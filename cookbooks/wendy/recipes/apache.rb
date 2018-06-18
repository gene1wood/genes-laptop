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

# web_app "gene.security.allizom.org" do
#   server_name 'gene.security.allizom.org'
#   server_port 443
#   docroot '/var/www/html'
#   cookbook 'wendy'
#   cert_chain_filename '/etc/ssl/certs/fullchain.pem'
#   private_key_filename '/etc/ssl/private/privkey.pem'
#   template 'apache/ssl_site.conf.erb'
#   oidc_crypto_passphrase node['apache']['gene.security.allizom.org']['oidc_crypto_passphrase']
# end



firewall_rule 'http/https' do
  protocol :tcp
  port     [80, 443]
#  notifies :enable, 'firewall[default]'
end



  # * directory[/var/lock/apache2] action create
  #   - change owner from 'www-data' to 'root'
