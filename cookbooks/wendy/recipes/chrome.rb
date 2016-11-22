#
# Cookbook Name:: wendy
# Recipe:: chrome
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

# We're doing this instead of creating the apt repository because the chrome package
# creates the apt repository itself
remote_dpkg 'google-chrome-stable' do
  source "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  not_if { File.exists?("#{Chef::Config['file_cache_path']}/google-chrome-stable_current_amd64.deb") }
end


node['chrome']['profiles'].each do |profile|
    template "#{base_homedir}/.local/share/applications/#{profile}.desktop" do
        source 'chrome.desktop.erb'
        owner node['base_user']['username']
        group node['base_user']['username']
        mode '0644'
        variables({
            :name => profile,
            :base_homedir => base_homedir
        })
    end

    cookbook_file "#{base_homedir}/.local/share/applications/#{profile}.png" do
        source "#{profile}.png"
        owner node['base_user']['username']
        group node['base_user']['username']
        mode '0644'
    end
end

# :is_default is required because of this :
# http://kb.mozillazine.org/Opening_a_new_instance_of_your_Mozilla_application_with_another_profile
node['firefox']['profiles'].each do |profile|
    template "#{base_homedir}/.local/share/applications/#{profile}.desktop" do
        source 'firefox.desktop.erb'
        owner node['base_user']['username']
        group node['base_user']['username']
        mode '0644'
        variables({
            :name => profile,
            :base_homedir => base_homedir,
            :is_default => (node['firefox']['default'] == profile)
        })
    end

    cookbook_file "#{base_homedir}/.local/share/applications/#{profile}.png" do
        source "#{profile}.png"
        owner node['base_user']['username']
        group node['base_user']['username']
        mode '0644'
    end
end

#TODO :
# https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/
# https://addons.mozilla.org/en-US/firefox/addon/bug489729-disable-detach-and-t/
# https://addons.mozilla.org/en-US/firefox/addon/s3menu-wizard/developers
    # Close Window
    # Inspector
    # Quit
# Optional :
# https://addons.mozilla.org/en-us/firefox/addon/behind_the_overlay/
# https://addons.mozilla.org/en-US/firefox/addon/cam/
# https://addons.mozilla.org/en-US/firefox/addon/GitHub-awesome-autocomplete/
# https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/
# https://addons.mozilla.org/en-us/firefox/addon/reddit-enhancement-suite/
# https://addons.mozilla.org/en-US/firefox/addon/rehost-image/
