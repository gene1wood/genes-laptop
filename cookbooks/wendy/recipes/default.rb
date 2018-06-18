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
  source 'gpg.conf.erb'
  owner node['base_user']['username']
  group node['base_user']['username']
  mode '0600'
  variables({
      :basedir => node['gpg']['basedir'],
      :default_key => node['gpg']['default_key']
  })
end

# http://askubuntu.com/a/252192/14601
cookbook_file "#{base_homedir}/.config/gtk-3.0/gtk.css" do
  source 'gtk.css'
  owner node['base_user']['username']
  group node['base_user']['username']
end

service 'procps'

cookbook_file '/etc/sysctl.d/60-disable-ipv6.conf' do
  source 'sysctl.d/60-disable-ipv6.conf'
  notifies :start, 'service[procps]', :immediately
end

cookbook_file '/etc/default/grub' do
  source 'etc/default/grub'
  notifies :run, 'execute[update-grub]', :immediately
end

execute 'update-grub' do
  action :nothing
end

cookbook_file '/etc/fuse.conf' do
  source 'fuse.conf'
end

cookbook_file "#{base_homedir}/.migrc" do
  source 'migrc'
  owner node['base_user']['username']
  group node['base_user']['username']
end

# MANUAL : mig-loader
# Disabling this as when it runs it overwrites the config : https://github.com/mozilla/mig/issues/347
# I've also disabled the mig-agent service which the mig-loader installs with
# update-rc.d -f mig-agent remove
#
# cookbook_file "/etc/cron.d/mig-loader" do
#   source 'etc/cron.d/mig-loader'
# end

cookbook_file "#{base_homedir}/.pypirc" do
  source 'pypirc'
  owner node['base_user']['username']
  group node['base_user']['username']
  mode '0600'
end

service 'avahi-daemon'

cookbook_file "/etc/avahi/avahi-daemon.conf" do
  source 'avahi-daemon.conf'
  notifies :restart, 'service[avahi-daemon]', :delayed
end

# I'd disabled this for some reason, not sure why
# if this causes a problem again, note why here
cookbook_file "/usr/lib/pm-utils/sleep.d/45disablelidwakeup" do
 source 'usr/lib/pm-utils/sleep.d/45disablelidwakeup'
 mode '0755'
end

# https://wiki.archlinux.org/index.php/Power_management#Sleep_hooks

template "/etc/ddclient.conf" do
  source 'ddclient.conf.erb'
  mode '0600'
  variables({
      :domain_name => node['nsupdate.info']['domain_name'],
      :password => node['nsupdate.info']['password']
  })
end

# https://github.com/mixxxdj/mixxx/commit/56b8e3fb9e08a0b1b3b474aeef11eef4d7d37079#diff-d67062afe8552f2877ec13584f22cec9
cookbook_file "/lib/udev/rules.d/60-mixxx-usb.rules" do
  source "lib/udev/rules.d/60-mixxx-usb.rules"
end


=begin
# Todo
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


# Group membership
gene adm cdrom sudo dip plugdev fuse lpadmin sambashare vboxusers wireshark

sudo addgroup gene fuse
sudo addgroup gene lpadmin
sudo addgroup gene sambashare
sudo addgroup gene vboxusers
sudo addgroup gene wireshark

=end


