#
# Cookbook Name:: wendy
# Recipe:: sparkelshare
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

package 'sparkleshare'

directory "#{base_homedir}/.config/sparkleshare" do
  owner node['base_user']['username']
  group node['base_user']['username']
  mode '0755'
end

directory "#{base_homedir}/.config/sparkleshare/plugins" do
  owner node['base_user']['username']
  group node['base_user']['username']
  mode '0755'
end

sparkelshare_config_filename = "#{base_homedir}/.config/sparkleshare/config.xml"
template sparkelshare_config_filename do
  owner node['base_user']['username']
  group node['base_user']['username']
  mode '0644'
  source 'sparkleshare/config.xml.erb'
  variables({
      :fullname => node['base_user']['fullname'],
      :email => node['base_user']['email'],
  })
  not_if { File.exists?(sparkelshare_config_filename) }
end

file "#{base_homedir}/.config/sparkleshare/sparkleshare.#{node['base_user']['email']}.key" do
    content node['sparkleshare']['private_key']
    owner node['base_user']['username']
    group node['base_user']['username']
    mode '0600'
end

file "#{base_homedir}/.config/sparkleshare/sparkleshare.#{node['base_user']['email']}.key.pub" do
    content node['sparkleshare']['public_key']
    owner node['base_user']['username']
    group node['base_user']['username']
    mode '0644'
end

template "#{base_homedir}/.config/sparkleshare/plugins/#{node['sparkleshare']['hostname']}.xml" do
  owner node['base_user']['username']
  group node['base_user']['username']
  mode '0644'
  source 'sparkleshare/plugin.erb'
  variables({
      :username => node['sparkleshare']['username'],
      :hostname => node['sparkleshare']['hostname'],
      :path => node['sparkleshare']['path']
  })
end

apt_repository 'gencfsm' do
  uri 'ppa:gencfsm'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key '0F68ADCA'
end

package 'gnome-encfs-manager'

# I think we don't need to do this as gnome-encfs-manager handles creating the mount dir

# directory node['sparkleshare']['encfs_target'] do
#   owner node['base_user']['username']
#   group node['base_user']['username']
#   not_if { ( node['filesystem'].values.select {|f| f['mount'] == node['sparkleshare']['encfs_target']}.length == 1 ) or File.exists?(node['sparkleshare']['encfs_target']) }
# end

execute "configure gnome-encfs-manager" do
  command "gksudo -u #{node['base_user']['username']} gnome-encfs-manager import_stash #{node['sparkleshare']['encfs_source']} #{node['sparkleshare']['encfs_target']}"
  not_if "gksudo -u #{node['base_user']['username']} gnome-encfs-manager is_configured #{node['sparkleshare']['encfs_source']}"
  # TODO : Add Secrets mount
end

