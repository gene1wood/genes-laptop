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
  checksum '3bed70c2eac576d85673204919ae4b16fadf4a70c65f80360e0dc0eb820ff4a4'
  notifies :run, 'execute[load fonts]', :immediately
end

execute "load fonts" do
  command "unzip #{font_package_filename} source-code-pro*/OTF/*.otf -d #{base_homedir}/.fonts"
  notifies :run, 'execute[update font cache]', :delayed
  action :nothing
end

for font in [
    'Friz Quadrata Bold BT.ttf',
    'OpenSans-Light.ttf',
    'Zapf Calligraphic 801 BT.ttf'] do
  cookbook_file "#{base_homedir}/.fonts/#{font}" do
    source "fonts/#{font}"
    owner node['base_user']['username']
    group node['base_user']['username']
    notifies :run, 'execute[update font cache]', :delayed
  end
end

execute "update font cache" do
  command "fc-cache --force --verbose"
  action :nothing
end