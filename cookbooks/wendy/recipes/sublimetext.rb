#
# Cookbook Name:: wendy
# Recipe:: sublimetext
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

apt_repository 'sublime-text-3' do
  uri 'ppa:webupd8team/sublime-text-3'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'EEA14886'
end

package 'sublime-text-installer'

directory "#{base_homedir}/.config/sublime-text-3" do
  user node['base_user']['username']
  group node['base_user']['username']
  mode '0700'
end

directory "#{base_homedir}/.config/sublime-text-3/Local" do
  user node['base_user']['username']
  group node['base_user']['username']
  mode '0700'
end

file "#{base_homedir}/.config/sublime-text-3/Local/License.sublime_license" do
  user node['base_user']['username']
  group node['base_user']['username']
  mode '0644'
  content node['sublime-text']['license']
end

directory "#{base_homedir}/.config/sublime-text-3/Packages" do
  user node['base_user']['username']
  group node['base_user']['username']
  mode '0700'
end

directory "#{base_homedir}/.config/sublime-text-3/Packages/User" do
  user node['base_user']['username']
  group node['base_user']['username']
  mode '0700'
end

cookbook_file "#{base_homedir}/.config/sublime-text-3/Packages/User/Preferences.sublime-settings" do
  source 'sublime-text/Preferences.sublime-settings'
  user node['base_user']['username']
  group node['base_user']['username']
  mode '0640'
end
