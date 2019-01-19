#
# Cookbook Name:: wendy
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

user node['base_user']['username'] do
  comment "#{node['base_user']['fullname']},,,"
  action :modify
end

group 'santaclara' do
  gid 3000
  append true
  members [node['base_user']['username']]
end

['fuse', 'lpadmin', 'sambashare', 'vboxusers', 'wireshark', 'docker'].each do |group_name|
  group group_name do
    append true
    members [node['base_user']['username']]
    action :manage  # Manage an existing group. This action does nothing if the group does not exist.
  end
end


file '/etc/sudoers.d/custom' do
  content "%sudo  ALL=(ALL:ALL) NOPASSWD: ALL"
  mode '0440'
end

include_recipe 'firewall::default'

include_recipe 'wendy::packages'
include_recipe 'wendy::sublimetext'
include_recipe 'wendy::chrome'
include_recipe 'wendy::git'
include_recipe 'wendy::sparkleshare'
include_recipe 'wendy::publicaccess'
include_recipe 'wendy::tinc'
include_recipe 'wendy::apache'
include_recipe 'wendy::tools'
include_recipe 'wendy::firewall'
include_recipe 'wendy::fonts'
include_recipe 'wendy::teamviewer'
include_recipe 'wendy::inkscape'
include_recipe 'wendy::btsync'

# MANUAL : desktop recipe
# include_recipe 'wendy::desktop'
# include_recipe 'wendy::desktoptest'




template "#{base_homedir}/.gnupg/gpg.conf" do
  source 'homedir/.gnupg/gpg.conf.erb'
  owner node['base_user']['username']
  group node['base_user']['username']
  mode '0600'
  variables({
                :basedir => node['gpg']['basedir'],
                :default_key => node['gpg']['default_key']
            })
end

directory "#{base_homedir}/.gnupg/private-keys-v1.d" do
  action :delete
  only_if { ::Dir.exists?(name) and ::Dir.empty?(name) }
end

link "#{base_homedir}/.gnupg/private-keys-v1.d" do
  owner node['base_user']['username']
  group node['base_user']['username']
  to "#{base_homedir}/code/keybase/gene_wood/gene-secrets/Keys and Certs/gpg/private-keys-v1.d"
end

# http://askubuntu.com/a/252192/14601
cookbook_file "#{base_homedir}/.config/gtk-3.0/gtk.css" do
  source 'homedir/.config/gtk-3.0/gtk.css'
  owner node['base_user']['username']
  group node['base_user']['username']
end



cookbook_file "#{base_homedir}/.pypirc" do
  source 'homedir/.pypirc'
  owner node['base_user']['username']
  group node['base_user']['username']
  mode '0600'
end

directory "#{base_homedir}/.ssh" do
  owner node['base_user']['username']
  group node['base_user']['username']
  mode '0700'
end

directory "#{base_homedir}/.ssh/config.d" do
  owner node['base_user']['username']
  group node['base_user']['username']
  mode '0755'
end

file "#{base_homedir}/.ssh/config" do
  owner node['base_user']['username']
  group node['base_user']['username']
  mode '0644'
  content "# https://superuser.com/a/1142813/57284\nInclude config.d/*\n"
end

for filename in ['default',
                 'git-internal.mozilla.org'] do
  cookbook_file "#{base_homedir}/.ssh/config.d/#{filename}" do
    source "homedir/.ssh/config.d/#{filename}"
    owner node['base_user']['username']
    group node['base_user']['username']
    mode '0644'
  end
end


# TODO : Fix the touchpad right click in 18.04
# https://itsfoss.com/fix-right-click-touchpad-ubuntu/

=begin
# MANUAL
* install mozilla root ca in Firefox
* crashplan
* git clone https://github.com/MoriTanosuke/HiDPI-Steam-Skin.git /home/gene/.local/share/Steam/skins/HiDPI-Steam-Skin




# Manual steps

# Use nvidia drivers
```
sudo ubuntu-drivers autoinstall
sudo apt-get remove xserver-xorg-video-nouveau
```

# Set firefox and chrome settings
Addons
* https://addons.mozilla.org/en-US/firefox/addon/disable-ctrl-q-shortcut/

# Load gnome-terimal settings
```
gconftool-2 --load #{base_homedir}/gnome-terminal.settings
```

# Copy over wifi configs
copy over /etc/NetworkManager/system-connections
update all "mac-address" values
```
sed -i -e 's/mac-address=8C:70:5A:4E:97:38/mac-address=5C:C5:D4:DF:34:7D/' /etc/NetworkManager/system-connections/*
```
bring over any passwords from the ubuntu password store that you want

# Sparkelshare
Run sparkleshare and choose "Add hosted project"
Select the plugin that's been configured
Wait while Sparkleshare downloads
It looks like not doing a full clone doesn't work. If you do you then have to do a `git fetch --unshallow` to fetch the entire archive
  https://github.com/hbons/SparkleShare/issues/1478#issuecomment-39570845

# OpenVPN
Launch vpn connections to enter password and store in Ubuntu pwd store
Setup mozilla vpns
Setup sonic vpns

# Vidyo
Have to type in the https://v.mozilla.com/ URL to login initially

# SSH
Copy in ssh keys (priv, pub), known_hosts and config

# Printer
Add rasperrypi

# Transmission Remote
Setup dorothy

# Firefox
Copy over grease monkey scripts

# Video drivers Quadro K1100M
We don't download newest nvidia driver because ubuntu adds /usr/lib/nvidia/pre-install which prevents
installing newer drivers

Set performance to Max to address artifacts and diagonal screen tearing
https://devtalk.nvidia.com/default/topic/770136/linux/ubuntu-gnome-3-10-lts-14-04-redraw-glitches-with-nvidia-340-29/post/4293440/#4293440

# pip
install pip (not python-pip since we a new version) https://pip.pypa.io/en/stable/installing/
pip install pyzmail
pip install cfn-pyplates
pip intsall boto # instead of apt-get install python-boto to get newer version
pip install kappa
pip install virtualenv
pip install git+git://github.com/sigmavirus24/github3.py.git@baf51f3eb3806015fde37dd446b44d7628cd0c3f
pip install IPy
pip install google-api-python-client
pip install wheel
pip install youtube_dl
pip install pytest
pip install pylabels
pip install coverage
pip install zappa

# private-chrome
In private-chrome non-icognito window install adblock
* https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm?hl=en
Allow in icognito the adblocker


# yubikey-personalization-gui

wget https://github.com/Yubico/yubikey-personalization-gui/archive/yubikey-personalization-gui-3.1.23.tar.gz
unp yubikey-personailzation-gui-*.tgz
sudo apt-get install libusb-1.0-0-dev qt4-qmake libykpers-1-dev libyubikey-dev libqt4-dev libykpers-1-1
qmake && make
gksudo build/release/yubikey-personalization-gui 


bzr whoami "#{node['base_user']['fullname']} <#{node['base_user']['email']}>"
bzr launchpad-login gene.wood

# Windows programs
Exact Audio Copy

# PyCharm
Install
License
Patch bin/pycharm.sh
    # --------------------------------------------------------------------
    # Workaround to prevent keyboard input from being blocked by IBus
    # https://youtrack.jetbrains.com/issue/IDEA-78860
    XMODIFIERS=""
    export XMODIFIERS
    # --------------------------------------------------------------------

Configure Chalice
https://github.com/awslabs/chalice/pull/216#issuecomment-270355138

# Audacious
Enable Crossfade plugin
set time to 10 seconds and 5 seconds
Enable Remove silence plugin

# SpiderOak One
# https://support.spideroak.com/hc/en-us/articles/115003763443-Replacing-a-Computer-or-Hard-Disk
Login to SpiderOak App
Create a new computer

# Mouse and touchpad
Set touchpad to "natural scrolling"=Off

=end


