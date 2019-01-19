#
# Cookbook Name:: wendy
# Recipe:: sublimetext
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

# apt_repository 'sublime-text-3' do
#   uri 'ppa:webupd8team/sublime-text-3'
#   distribution node['lsb']['codename']
#   components ['main']
#   keyserver 'keyserver.ubuntu.com'
#   key 'EEA14886'
# end


apt_repository 'sublime-text' do
  uri 'https://download.sublimetext.com/'
  # distribution node['lsb']['codename']
  distribution 'apt/stable/'
  key 'https://download.sublimetext.com/sublimehq-pub.gpg'
end

# package 'sublime-text-installer'
package 'sublime-text'

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

# directory "#{base_homedir}/.config/sublime-text-3/Packages" do
#   user node['base_user']['username']
#   group node['base_user']['username']
#   mode '0700'
# end
#
# directory "#{base_homedir}/.config/sublime-text-3/Packages/User" do
#   user node['base_user']['username']
#   group node['base_user']['username']
#   mode '0700'
# end

# cookbook_file "#{base_homedir}/.config/sublime-text-3/Packages/User/Preferences.sublime-settings" do
#   source 'sublime-text/Preferences.sublime-settings'
#   user node['base_user']['username']
#   group node['base_user']['username']
#   mode '0640'
# end

# {
#     "draw_white_space": "all",
#     "font_size": 11,
#     "ignored_packages":
#         [
#         "Vintage"
# ],
#     "open_files_in_new_window": false,
# "scroll_speed": 0,
#     "tab_size": 4,
#     "translate_tabs_to_spaces": true
# }


# Post Install steps
# MANUAL : sublime-text plugins
# https://packagecontrol.io/installation
# https://github.com/SublimeText-Markdown/MarkdownEditing
# https://github.com/dzhibas/SublimePrettyJson