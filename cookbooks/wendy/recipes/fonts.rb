#
# Cookbook Name:: wendy
# Recipe:: fonts
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

directory "#{base_homedir}/.fonts" do
  owner node['base_user']['username']
  group node['base_user']['username']
end

font_package_filename = "#{Chef::Config['file_cache_path']}/source-code-pro.zip"
remote_file font_package_filename do
  source 'https://github.com/adobe-fonts/source-code-pro/archive/2.010R-ro/1.030R-it.zip'
  checksum 'a5c011502ad3bc628bb4fc3646cd387482819bd2a7182162cf15095fdce3d18c'
  notifies :run, 'execute[load fonts]', :immediately
end

execute "load fonts" do
  command "unzip #{font_package_filename} source-code-pro*/OTF/*.otf -d #{base_homedir}/.fonts && fc-cache --force --verbose"
  action :nothing
end
