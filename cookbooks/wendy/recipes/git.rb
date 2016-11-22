#
# Cookbook Name:: wendy
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

include_recipe 'git'

template "#{base_homedir}/.gitconfig" do
  source "gitconfig.erb"
  owner node['base_user']['username']
  group node['base_user']['username']
  mode "0664"
  variables({
      :fullname => node['base_user']['fullname'],
      :email => node['base_user']['email'],
      :username => node['base_user']['username']
  })
end

cookbook_file "#{base_homedir}/.gitignore_global" do
  source "gitignore_global"
  owner node['base_user']['username']
  group node['base_user']['username']
  mode "0644"
end

remote_dpkg 'smartgit' do
  source "http://www.syntevo.com/downloads/smartgit/smartgit-7_1_3.deb"
  checksum "3c8442438131537f0c2e8a6656ea0827140238bbc2a3b04ff45e0f68afef3e21"
end


directory "#{base_homedir}/.smartgit" do
  owner node['base_user']['username']
  group node['base_user']['username']
  mode "0775"
end

directory "#{base_homedir}/.smartgit/6.5" do
  owner node['base_user']['username']
  group node['base_user']['username']
  mode "0775"
end

file "#{base_homedir}/.smartgit/6.5/license" do
  content node['smartgit']['license']
  owner node['base_user']['username']
  group node['base_user']['username']
  mode "0640"
end