#
# Cookbook Name:: wendy
# Recipe:: desktop
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

# Ubuntu 14.04 uses gnome-terminal 3.6.2 which still stores settings in gconf
# Not until 3.8 does gnome-terminal start using dconf

desktop_settings '/apps/gnome-terminal/profiles/Default/use_custom_default_size' do
  type 'bool'
  value "true"
  user node['base_user']['username']
  provider 'desktop_gconf'
end

desktop_settings '/apps/gnome-terminal/profiles/Default/default_size_columns' do
  type 'int'
  value "200"
  user node['base_user']['username']
  provider 'desktop_gconf'
end

desktop_settings '/apps/gnome-terminal/profiles/Default/default_size_rows' do
  type 'int'
  value "60"
  user node['base_user']['username']
  provider 'desktop_gconf'
end

desktop_settings '/apps/gnome-terminal/profiles/Default/font' do
  type 'string'
  value 'Source Code Pro 12'
  user node['base_user']['username']
  provider 'desktop_gconf'
end

desktop_settings '/apps/gnome-terminal/profiles/Default/scrollback_unlimited' do
  type 'bool'
  value 'true'
  user node['base_user']['username']
  provider 'desktop_gconf'
end

desktop_settings '/apps/gnome-terminal/profiles/Default/use_custom_default_size' do
  type 'bool'
  value 'true'
  user node['base_user']['username']
  provider 'desktop_gconf'
end

# gnome-terminal presentation
# font Source Code Pro 20

desktop_settings "default-folder-viewer" do
  schema "org.gnome.nautilus.preferences"
  type "string"
  value "'list-view'"
  user node['base_user']['username']
end

desktop_settings "show-hidden-files" do
  schema "org.gnome.nautilus.preferences"
  type "boolean"
  value "true"
  user node['base_user']['username']
end

desktop_settings "scale-factor" do
  schema "com.ubuntu.user-interface"
  type "a{si}"
  value "{'DP1': 8, 'eDP2': 12, 'DP2': 12, 'eDP1': 12}"
  user node['base_user']['username']
end

desktop_settings "text-scaling-factor" do
  schema "org.gnome.desktop.interface"
  type "integer"
  value "1.875"
  user node['base_user']['username']
end

desktop_settings "lid-close-ac-action" do
  schema "org.gnome.settings-daemon.plugins.power"
  type "string"
  value "nothing"
  user node['base_user']['username']
end

desktop_settings "lid-close-battery-action" do
  schema "org.gnome.settings-daemon.plugins.power"
  type "string"
  value "nothing"
  user node['base_user']['username']
end

desktop_settings "button-power" do
  schema "org.gnome.settings-daemon.plugins.power"
  type "string"
  value "shutdown"
  user node['base_user']['username']
end

# Vino VNC server listen only on loopback
desktop_settings "network-interface" do
  schema "org.gnome.Vino"
  type "string"
  value "lo"
  user node['base_user']['username']
end


=begin
# TODO This is not persisting for some reason

rebooting after this seems to make these values persist

gsettings get org.gnome.desktop.interface text-scaling-factor
gsettings get com.ubuntu.user-interface scale-factor
gsettings get org.gnome.nautilus.preferences show-hidden-files
gsettings get org.gnome.nautilus.preferences default-folder-viewer





deprecated :

cookbook_file "#{base_homedir}/gnome-terminal.settings" do
  owner node['base_user']['username']
  group node['base_user']['username']
  source "gnome-terminal.settings"
#  notifies :run, 'execute[configure gnome-terminal]', :immediately
end

execute "configure gnome-terminal" do
  # This doesn't work for some reason. If you run it by hand as the base_user it works
  # Something to do with dbus
  # gksudo doesn't seem to fix it either
  user node['base_user']['username']
  command "gksudo -u #{node['base_user']['username']} gconftool-2 --config-source=xml::#{base_homedir}/.gconf --load #{base_homedir}/gnome-terminal.settings"
  # command "gksudo #{node['base_user']['username']} gconftool-2 --direct --config-source=xml::#{base_homedir}/.gconf --load #{base_homedir}/gnome-terminal.settings"
  action :nothing
end

#execute "configure nautilus" do
#  user node['base_user']['username']
#  command "dbus-launch gsettings set org.gnome.nautilus.preferences default-folder-viewer list-view"
#  not_if "dbus-launch gsettings get org.gnome.nautilus.preferences default-folder-viewer | grep \"'list-view'\""
#end

=end