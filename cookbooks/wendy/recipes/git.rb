#
# Cookbook Name:: wendy
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

if node["platform_version"] == "16.04"
  # http://askubuntu.com/a/571633/14601
  apt_repository 'git-core-ppa' do
    uri 'ppa:git-core/ppa'
    distribution node['lsb']['codename']
  end

  git_client 'default' do
    package_action :upgrade
    # Ubuntu git package versions for some reason begin with "1:"
    # This installs the newest git 2 version that begins with "1:2"
    # https://github.com/chef/chef/issues/5578
    package_version "1:2\*"
  end
end
if node["platform_version"] == "18.04"
  package 'git'
end

template "#{base_homedir}/.gitconfig" do
  source "homedir/.gitconfig.erb"
  owner node['base_user']['username']
  group node['base_user']['username']
  mode "0664"
  variables({
      :fullname => node['base_user']['fullname'],
      :email => node['base_user']['email'],
      :username => node['base_user']['username'],
      :signingkey => node['gpg']['default_key'],
      :gpg_binary_name => node["platform_version"] == "16.04" ? 'gpg2' : 'gpg'
  })
end

cookbook_file "#{base_homedir}/.gitignore_global" do
  source "homedir/.gitignore_global"
  owner node['base_user']['username']
  group node['base_user']['username']
  mode "0644"
end

remote_dpkg 'smartgit' do
  source "https://www.syntevo.com/downloads/smartgit/archive/smartgit-17_1_6.deb"
  checksum "8982cd19165794653528012b0c1e9ee8de203585cd09bde6ed55035e88a63688"
end

directory "#{base_homedir}/.smartgit" do
  owner node['base_user']['username']
  group node['base_user']['username']
  mode "0775"
end

directory "#{base_homedir}/.smartgit/17" do
  owner node['base_user']['username']
  group node['base_user']['username']
  mode "0775"
end

file "#{base_homedir}/.smartgit/17/license" do
  content node['smartgit']['license']
  owner node['base_user']['username']
  group node['base_user']['username']
  mode "0640"
end

gitcrypt_filename = 'git-crypt_0.5.0-1_amd64.deb'
gitcrypt_version = '0.5.0-1'
cookbook_file "#{Chef::Config['file_cache_path']}/#{gitcrypt_filename}" do
  source gitcrypt_filename
end

dpkg_package 'git-crypt' do
  source "#{Chef::Config['file_cache_path']}/#{gitcrypt_filename}"
  version gitcrypt_version
  not_if "dpkg -s #{@name}"
end

require "yaml"

directory "#{base_homedir}/.github" do
  owner node['base_user']['username']
  group node['base_user']['username']
end

file "#{base_homedir}/.github/fork_github_repo.yaml" do
  content YAML::dump(YAML::dump(node[:github]['fork-github-repo'].to_hash).gsub('!map:Mash',''))
  owner node['base_user']['username']
  group node['base_user']['username']
  mode "0600"
end

# MANUAL : Set SmartGit to "Sign All Commits"