#
# Cookbook Name:: wendy
# Recipe:: eclipse
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# This installs 3.8 which we don't want
# package 'eclipse-platform'

liclipse_filename = 'liclipse_2.2.0_linux.gtk.x86_64.tar.gz'
remote_file "#{Chef::Config['file_cache_path']}/#{liclipse_filename}" do
  source "https://googledrive.com/host/0BwwQN8QrgsRpLVlDeHRNemw3S1E/LiClipse%202.2.0/#{liclipse_filename}"
  checksum "577741a46d9aee533df36fdd5c999047bd5fed5485bbd03d694705710fc35094"
  notifies :run, 'execute[extract liclipse]', :immediately
end

execute 'extract liclipse' do
  command ['tar',
          '--extract',
          '--no-same-permissions',
          '--no-same-owner',
          '--gunzip',
          "--file #{Chef::Config['file_cache_path']}/#{liclipse_filename}",
          '--directory /opt'
          ].join(" ")
  action :nothing
end

link "/usr/bin/liclipse" do
  to "/opt/liclipse/LiClipse"
end

cookbook_file "/usr/share/applications/liclipse.desktop" do
  source "liclipse.desktop"
end

# eclipse_importprojects_filename = 'com.seeq.eclipse.importprojects_1.2.0.jar'
# remote_file "/opt/liclipse/plugins/#{eclipse_importprojects_filename}" do
#   source "https://github.com/seeq12/eclipse-import-projects-plugin/raw/master/jar/#{eclipse_importprojects_filename}"
#   checksum "96584cd3fdb0da80608d269a2c20e8afe7b8877352a5414f1ec7f862fb77cc33"
# end
