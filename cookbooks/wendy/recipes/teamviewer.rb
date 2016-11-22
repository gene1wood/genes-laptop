#
# Cookbook Name:: wendy
# Recipe:: teamviewer
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# http://askubuntu.com/a/363083/14601
for package_name in [
    'libgcc1:i386',
    'libasound2:i386',
    'libfontconfig1:i386',
    'libfreetype6:i386',
    'libjpeg62:i386',
    'libpng12-0:i386',
    'libsm6:i386',
    'libxdamage1:i386',
    'libxext6:i386',
    'libxfixes3:i386',
    'libxrandr2:i386',
    'libxrender1:i386',
    'libxtst6:i386',
    'zlib1g:i386'] do
  package package_name
end

remote_dpkg 'teamviewer' do
  source "http://downloadus2.teamviewer.com/download/teamviewer_i386.deb"
  checksum "66f2444b660b87f2fdc1d19949b94bbd840982d51c3405e4a53799cd6a6c6090"
end

service 'teamviewerd' do
  action [:stop, :disable]
end