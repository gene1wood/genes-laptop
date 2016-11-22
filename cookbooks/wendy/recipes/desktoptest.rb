#
# Cookbook Name:: wendy
# Recipe:: desktop
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

desktop_settings "default-folder-viewer" do
  schema "org.gnome.nautilus.preferences"
  type "string"
  value "list-view"
  user node['base_user']['username']
end
