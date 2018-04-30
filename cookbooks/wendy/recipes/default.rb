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
include_recipe 'wendy::crashplan'
include_recipe 'wendy::tools'
include_recipe 'wendy::firewall'
include_recipe 'wendy::eclipse'
include_recipe 'wendy::fonts'
include_recipe 'wendy::teamviewer'
include_recipe 'wendy::inkscape'
include_recipe 'wendy::btsync'

remote_file "/usr/lib/firefox-addons/distribution/extensions/support@lastpass.com.xpi" do
  # This will only install lastpass on new Firefox profiles, not existing profiles
  source "https://lastpass.com/download/cdn/lp4.xpi"
  checksum 'e28cb6d57aa26ecc6be25e58ecc1f12bf7da8b0dcd4680541f68984c7b613219' # 4.0
  # checksum 'e4b5d91ea880f88d8f5fa3f4d35e377b5144f665c5d037ecb9807d30100f1bfb' # 3.2.16
end

remote_file "/usr/lib/firefox-addons/distribution/extensions/uBlock0@raymondhill.net.xpi" do
  # This will only install ublock origin on new Firefox profiles, not existing profiles
  source "https://github.com/gorhill/uBlock/releases/download/1.0.0.0/uBlock0.firefox.xpi"
  checksum 'b586dea639524752fdfd81901ce7ff247955df0f8bc094fd00484175c5fb452b' # 1.0.0.0
end

# include_recipe 'wendy::desktop'
include_recipe 'wendy::desktoptest'


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

cookbook_file "/etc/cron.d/mig-loader" do
  source 'etc/cron.d/mig-loader'
end

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
# if this causes a problem agian, note why here
cookbook_file "/usr/lib/pm-utils/sleep.d/45disablelidwakeup" do
 source 'usr/lib/pm-utils/sleep.d/45disablelidwakeup'
 mode '0755'
end

# https://wiki.archlinux.org/index.php/Power_management#Sleep_hooks


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


