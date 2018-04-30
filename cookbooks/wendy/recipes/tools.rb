#
# Cookbook Name:: wendy
# Recipe:: tools
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

directory "#{base_homedir}/bin" do
  owner node['base_user']['username']
  group node['base_user']['username']
end

directory "/root/bin"

for filename in ['smartgit',
                 'setprompt',
                 'setupbash',
                 'git-prompt.sh',
                 'show',
                 'toggle_trackpad',
                 'alternate_colors',
                 'aws_assume_role',
                 'ct',
                 'ferry-alert',
                 'we-are-at-mozilla',
                 'offscreen-window-restore',
                 'set_aws_environment_variables',
                 'touchpad',
                 'find-desktop',
                 'mozilla-socks-proxy',
                 'dorothy-socks-proxy',
                 'screencast',
                 'pack_animation.py',
                 'ngrok'] do
    cookbook_file "#{base_homedir}/bin/#{filename}" do
      source "bin/#{filename}"
      owner node['base_user']['username']
      group node['base_user']['username']
      mode '0755'
    end
end

for filename in ['move_all_public_files_to_gene_scans',
                 'find_core_dumps',
                 'free-up-space-on-boot-volume'] do
    cookbook_file "/root/bin/#{filename}" do
      source "bin/#{filename}"
      mode '0755'
    end
end


cookbook_file "#{base_homedir}/.bashrc" do
  source "bashrc"
  owner node['base_user']['username']
  group node['base_user']['username']
end

cookbook_file "#{base_homedir}/.bash_aliases" do
  source "bash_aliases"
  owner node['base_user']['username']
  group node['base_user']['username']
end

cookbook_file "/var/www/html/custom-proxy-config.pac" do
  source "custom-proxy-config.pac"
end
