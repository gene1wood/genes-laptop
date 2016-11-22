#
# Cookbook Name:: wendy
# Recipe:: inkscape
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

package 'inkscape'

cookbook_file "#{base_homedir}/.config/inkscape/keys/default.xml" do
  source 'inkscape/default.xml'
  owner node['base_user']['username']
  group node['base_user']['username']
end

inkscape_tables_filename = 'inkscape-table-1.0.tar.gz'
remote_file "#{Chef::Config['file_cache_path']}/#{inkscape_tables_filename}" do
  source "http://downloads.sourceforge.net/project/inkscape-tables/#{inkscape_tables_filename}"
  checksum "f17fe1c989c88e40131b3ebd1bd45d75049a807e6aace9fc0e714e012c194863"
  notifies :run, 'execute[extract inkscape-tables]', :immediately
end

execute 'extract inkscape-tables' do
  command ['tar',
          '--extract',
          '--no-same-owner',
          '--gunzip',
          '--strip-components=2',
          "--file #{Chef::Config['file_cache_path']}/#{inkscape_tables_filename}",
          '--directory /usr/share/inkscape/extensions'
          ].join(" ")
  action :nothing
end
