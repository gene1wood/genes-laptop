#
# Cookbook Name:: wendy
# Recipe:: packages
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'base OS packages' do
  package_name [
    'openssh-server',
    'sshfs',
    'curl',
    'apt-file',
    'encfs',
    'vlc',
    'meld',
    'pdftk',
    'samba',
    'screen',
    'shutter',
    'transmission-remote-gtk',
    'gconf-editor',
    'openvpn',
    'network-manager-openvpn',
    'ruby',
    'gksu',
    'dconf-editor',
    'gimp',
    'unp',
    'dos2unix',
    'dosbox',
    'flac',
    'imagemagick',
    'inkscape',
    'knockd',
    'krename',
    'lame',
    'mnemonicode',
    'nmap',
    'recordmydesktop',
    'unetbootin',
    'wireshark',
    'xtightvncviewer',
    'audacious',
    'bsdgames',
    'audacity',
    'at',
    'httpie',
    'ipython',
    'python-bs4',
    'python-html2text',
    'whois',
    'python-yaml',
    'gtk-recordmydesktop',
    'openshot',
    'iperf',
    'powertop',
    'lsyncd',
    'subversion',
    'traceroute',
    'sysv-rc-conf',
    'icedtea-7-plugin',
    'xsel',
    'android-tools-adb',
    'android-tools-fastboot',
    'heimdall-flash',
    'bzr',
    'golang',
    'yubikey-personalization-gui',
    'secure-delete',
    'qrencode',
    'maildir-utils',
    'vbrfix',
    'mp3diags',
    'wine',
    'openjdk-7-jdk',
    'gameconqueror',
    'htop',
    'avidemux',
    'libav-tools',
    'minicom',
    'xinetd',
    'tftpd',
    'tftp',
    'snmp',
    'mencoder',
    'maven2',
    'exfat-fuse',
    'exfat-utils',
    'mailutils',
    'termsaver',
    'unrar',
    'php5-cli',
    'sqlite3',
    'phatch',
    'puddletag',
    'mame',
    'mame-tools',
    'pandoc',
    'unity-tweak-tool',
    'httping',
    'alsa-tools-gui',
    'idn']
end
# https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1296270
for package_name in ['myspell-en-au',
                     'myspell-en-gb',
                     'myspell-en-za',
                     'unity-webapps-common',
                     'gnome-screensaver',
                     'gnome-orca']
  package package_name do
    action :remove
  end
end

############ Remote Dpkg Files ##################

remote_dpkg 'keybase' do
  source "https://prerelease.keybase.io/keybase_amd64.deb"
  checksum "2e05591119606f26337ca14d13547c815f4443f26384157ec6685764b8c2ae93"
  action :install # keybase auto updates itself so we should skip this if it's installed
  # source "https://dist.keybase.io/linux/deb/keybase-latest-amd64.deb"
  # checksum "0fa9860a0ce77b0507b440115a55c710e53d71eb4d181014f4b7150c341736db"
end

remote_dpkg 'spideroakone' do
  source "https://spideroak.com/getbuild?platform=ubuntu&arch=x86_64"
  filename "spideroakone.deb"
  checksum "3366d38fd055668cc8a86adc914ace8675ba7babfc479f094041707b21c11961"
  action :install # spideroakone auto updates itself so we should skip this if it's installed
end

remote_dpkg 'steam' do
  source "https://steamcdn-a.akamaihd.net/client/installer/steam.deb"
  checksum "6a0837afaef3e5ab6eae1a027384b8b94edcb92f5edb23a05b70dbf7eed4bb6d"
  # No need to upgrade this package because steam has it's own internal self
  # updating mechanism
  not_if "dpkg-query -W 'steam'"
end

remote_dpkg 'encryptr' do
  source "https://spideroak.com/dist/encryptr/signed/linux/deb/encryptr_2.0.0-1_amd64.deb"
  checksum "d96c3108ed1fb2d10988eb21e2359331fcfb5f2836276be7861ab26d713553fc"
  action :install # encryptr auto updates itself so we should skip this if it's installed
end

remote_dpkg 'mig-loader' do
  source "https://s3.amazonaws.com/infosec-mig/public/it-ws/mig-loader_20160817-0.e43ead4.prod_amd64.deb"
  checksum "d1f82cced747275536a5ccd7e73b41655e71c493d40d2d9e56bf412a57231dcc"
  action :install # mig-loader auto updates itself so we should skip this if it's installed
end

remote_dpkg 'nomachine' do
  source "http://download.nomachine.com/download/5.1/Linux/nomachine_5.1.26_1_amd64.deb"
  checksum "924a2a1f67bc9e1d7c1d5bae2764bd790632a0af5c811cd8e56f1637de7be8f7"
  action :install # nomachine auto updates itself so we should skip this if it's installed
end

file '/etc/init/nxserver.override' do
  content "# https://www.nomachine.com/TR01N06343\nmanual\n"
end

remote_dpkg 'google-earth-stable' do
  source "https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb"
  # checksum "924a2a"
  action :install # this auto updates itself so we should skip this if it's installed
end

package ['python3-markdown',
         'python3-bs4',
         'wkhtmltopdf']

remote_dpkg 'remarkable' do
  source "https://remarkableapp.github.io/files/remarkable_1.62_all.deb"
  checksum "aca5b1ea7aa1953407fe122f67587a808371e0e61cbc7c7ff04c558a898cefff"
end

remote_dpkg 'Semaphor' do
  source "https://spideroak.com/releases/semaphor/debian"
  filename "Semaphor-amd64.deb"
  checksum "cb567dfe237996a625059f28dbb751be50e2d6799fd29e995b8843ac5acaab9f"
  action :install # semaphor auto updates itself so we should skip this if it's installed
end

########## Local Dpkg ############

vidyo_filename = "VidyoDesktopInstaller-ubuntu64-TAG_VD_3_6_3_017.deb"
vidyo_version = "3.6.3-017"
cookbook_file "#{Chef::Config['file_cache_path']}/#{vidyo_filename}" do
  source vidyo_filename
end

dpkg_package 'vidyodesktop' do
  source "#{Chef::Config['file_cache_path']}/#{vidyo_filename}"
  version vidyo_version
end

gitcrypt_filename = 'git-crypt_0.5.0-1_amd64.deb'
gitcrypt_version = '0.5.0-1'
cookbook_file "#{Chef::Config['file_cache_path']}/#{gitcrypt_filename}" do
  source gitcrypt_filename
end

dpkg_package 'git-crypt' do
  source "#{Chef::Config['file_cache_path']}/#{gitcrypt_filename}"
  version gitcrypt_version
end

########## Apt Repos #############

apt_repository 'virtualbox' do
  uri 'http://download.virtualbox.org/virtualbox/debian'
  distribution node['lsb']['codename']
  components ['contrib']
  keyserver 'keyserver.ubuntu.com'
  key '98AB5139'
end

package 'virtualbox-5.1'

# TODO : sudo usermod -a -G vboxusers node['base_user']['username']

# wget http://download.virtualbox.org/virtualbox/5.0.26/Oracle_VM_VirtualBox_Extension_Pack-5.0.26-108824.vbox-extpack
# sudo VBoxManage extpack install ./Oracle_VM_VirtualBox_Extension_Pack-4.2.12-84980.vbox-extpack

apt_repository 'rabbitvcs' do
  uri 'ppa:rabbitvcs/ppa'
  distribution node['lsb']['codename']
end

package 'rabbitvcs-nautilus3'

apt_repository 'yubico' do
  uri 'ppa:yubico/stable'
  distribution node['lsb']['codename']
end

package 'yubikey-neo-manager'
package 'yubioath-desktop'

apt_repository 'getdeb' do
  uri        'http://archive.getdeb.net/ubuntu'
  distribution 'trusty-getdeb'
  components ['games']
  key '46D7E7CF'
  keyserver 'keyserver.ubuntu.com'
  # This required manually running 'sudo apt-get update' to prevent the error
  # WARNING: The following packages cannot be authenticated!
  #    vulture-data vulture-nethack
  # STDERR: E: There are problems and -y was used without --force-yes
end

package 'vulture-nethack'

apt_repository 'vikoadi' do
  uri 'ppa:vikoadi/ppa'
  distribution node['lsb']['codename']
end

package 'indicator-kdeconnect'
package 'kdeconnect'

apt_repository 'maarten-baert' do
  uri 'ppa:maarten-baert/simplescreenrecorder'
  distribution node['lsb']['codename']
end

package 'simplescreenrecorder'
# package 'simplescreenrecorder-lib:i386'

execute 'accept oracle license' do
  command 'echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections'
  not_if 'dpkg-query -W "oracle-java8-installer"'
end

apt_repository 'webupd8team-java' do
  uri 'ppa:webupd8team/java'
  distribution node['lsb']['codename']
end

package 'oracle-java8-installer'

# http://blog.bittorrent.com/2016/02/18/official-linux-packages-for-sync-now-available/
apt_repository 'btsync' do
  uri 'http://linux-packages.getsync.com/btsync/deb'
  distribution 'btsync'
  components ['non-free']
  key 'http://linux-packages.getsync.com/btsync/key.asc'
end

package "btsync"

apt_repository 'daveg-attract' do
  uri 'ppa:daveg/attract'
  distribution node['lsb']['codename']
end

package 'attract'

# http://askubuntu.com/a/679519/14601
apt_repository 'fingerprint-fprint' do
  uri 'ppa:fingerprint/fprint'
  distribution node['lsb']['codename']
end

#package 'fprint packages' do
#  package_name [
#    'libfprint0',
#    'fprint-demo',
#    'libpam-fprintd',
#    'gksu-polkit']
#end

apt_repository 'stebbins-handbrake-releases' do
  uri 'ppa:stebbins/handbrake-releases'
  distribution node['lsb']['codename']
end

package 'handbrake-gtk'

# http://shutter-project.org/downloads/
apt_repository 'shutter-ppa' do
  uri 'ppa:shutter/ppa'
  distribution node['lsb']['codename']
end

package 'shutter'

# https://github.com/eosrei/emojione-color-font
apt_repository 'eosrei-fonts' do
  uri 'ppa:eosrei/fonts'
  distribution node['lsb']['codename']
end

package 'fonts-emojione-svginot'

# http://askubuntu.com/a/783983/14601
apt_repository 'heyarje-libav-11' do
  uri 'ppa:heyarje/libav-11'
  distribution node['lsb']['codename']
end

package 'libav-tools'

