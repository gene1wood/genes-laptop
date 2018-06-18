#
# Cookbook Name:: wendy
# Recipe:: packages
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_homedir = node['etc']['passwd'][node['base_user']['username']]['dir']

package 'base OS packages' do
  package_name %w[
    openssh-server
    sshfs
    curl
    apt-file
    encfs
    vlc
    meld
    pdftk
    samba
    screen
    shutter
    transmission-remote-gtk
    gconf-editor
    openvpn
    network-manager-openvpn
    ruby
    ruby-dev
    gksu
    dconf-editor
    gimp
    unp
    dos2unix
    dosbox
    flac
    imagemagick
    inkscape
    knockd
    krename
    lame
    mnemonicode
    nmap
    unetbootin
    wireshark
    xtightvncviewer
    audacious
    bsdgames
    audacity
    at
    httpie
    ipython
    python-bs4
    python-html2text
    whois
    python-yaml
    openshot
    iperf
    powertop
    lsyncd
    subversion
    traceroute
    sysv-rc-conf
    xsel
    android-tools-adb
    android-tools-fastboot
    heimdall-flash
    bzr
    golang
    yubikey-personalization-gui
    secure-delete
    qrencode
    maildir-utils
    vbrfix
    mp3diags
    wine
    gameconqueror
    htop
    minicom
    xinetd
    tftpd
    tftp
    snmp
    mencoder
    exfat-fuse
    exfat-utils
    mailutils
    termsaver
    unrar
    sqlite3
    phatch
    puddletag
    mame
    mame-tools
    pandoc
    texlive
    httping
    alsa-tools-gui
    idn
    yubikey-personalization
    compizconfig-settings-manager
    python-matplotlib
    moreutils
    playonlinux
    ddclient
    mkvtoolnix
    tvnamer
    tree
    smartmontools
    qreator
    redshift
    redshift-gtk
    gtkpod
    pwgen
    dstat
    iotop
    gparted
    pitivi
    oathtool
    network-manager-openvpn-gnome
    task
  ]
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

#################################################### Remote Dpkg Files ##########################################################

# https://keybase.io/docs/the_app/linux_expired_key
remote_dpkg 'keybase' do
  source "https://prerelease.keybase.io/keybase_amd64.deb"
  checksum "722c9a801f235d6aca21ecd18b1f077356aed1e57334b58d3c3095bcec82ce2e"
  action :install # keybase auto updates itself so we should skip this if it's installed
  # source "https://dist.keybase.io/linux/deb/keybase-latest-amd64.deb"
  # checksum "0fa9860a0ce77b0507b440115a55c710e53d71eb4d181014f4b7150c341736db"
end

remote_dpkg 'spideroakone' do
  source "https://spideroak.com/release/spideroak/deb_x64"
  filename "spideroakone.deb"
  checksum "a94d4ad3657d7437ee4ef5b7a5feb2687b78dafab45f94c6cb2fb5f246c9dcfe"
  action :install # spideroakone auto updates itself so we should skip this if it's installed
end

package 'python-apt'

remote_dpkg 'steam' do
  source "https://steamcdn-a.akamaihd.net/client/installer/steam.deb"
  checksum "45aa0aaec0183f667ae985667ef2ca4bab9391fbe0fa398ac9f2ca32dfb526d8"
  # No need to upgrade this package because steam has it's own internal self
  # updating mechanism
  not_if "dpkg-query -W 'steam'"
end

remote_dpkg 'encryptr' do
  source "https://spideroak.com/dist/encryptr/signed/linux/deb/encryptr_2.0.0-1_amd64.deb"
  checksum "d96c3108ed1fb2d10988eb21e2359331fcfb5f2836276be7861ab26d713553fc"
  action :install # encryptr auto updates itself so we should skip this if it's installed
end

package %w(python3-markdown python3-bs4 wkhtmltopdf gir1.2-webkit-3.0 gir1.2-javascriptcoregtk-3.0)

remote_dpkg 'remarkable' do
  source "https://remarkableapp.github.io/files/remarkable_1.62_all.deb"
  checksum "aca5b1ea7aa1953407fe122f67587a808371e0e61cbc7c7ff04c558a898cefff"
end

remote_dpkg 'Semaphor' do
  source "https://spideroak.com/release/semaphor/deb_x64"
  filename "semaphor_amd64.deb"
  checksum "dc86e96e4d6148f9e320d396ff25cb9291d582edd768bc8bdc706c454ffafa26"
  action :install # semaphor auto updates itself so we should skip this if it's installed
end

package 'libapache2-mod-auth-openidc'

package ['python-appindicator',
         'python-appdirs',
         'python-netifaces',
         'python-ipaddr',
         'python-psutil']
remote_dpkg 'mullvad' do
  # source "https://www.mullvad.net/download/latest/linux/"
  # Mullvad 63 introduced depenency on [python-wxgtk3.0](https://packages.ubuntu.com/search?keywords=python-wxgtk3.0) not present in Ubuntu 14.04
  # MANUAL : mullvad depending on Ubuntu distro
  source "https://www.mullvad.net/media/client/mullvad_62-1_all.deb"
  filename "mullvad_all.deb"
  checksum "7df59d9a8071dd6da6a531e162806328b04165694661221d99a8b7f4f988a6b8"
end

remote_dpkg 'rescuetime' do
  source "https://www.rescuetime.com/installers/rescuetime_current_amd64.deb"
  checksum "90b30405b98e8da7aa670acdcffa52e79ae212c1f833556646ab31455cd05708"
end


remote_dpkg 'geogebra5' do
  source "http://www.geogebra.net/linux/pool/main/g/geogebra5/geogebra5_5.0.390.0-569040_amd64.deb"
  checksum "207609735f1eb1fc6174fd5302102022fbbf8f7dfaba4cadfde2dda315524d55"
  action :install # auto updates itself so we should skip this if it's installed
end

package ['libqt5clucene5',
         'libqt5designer5',
         'libqt5help5',
         'python3-pyqt5',
         'python3-pyudev',
         'python3-sip']
remote_dpkg 'python3-multibootusb' do
  source "https://github.com/mbusb/multibootusb/releases/download/v8.8.0/python3-multibootusb_8.8.0-1_all.deb"
  checksum "8dd041f99b95a7b5a4140b27c85cbf3af75a14ae4bdf61202a3ca3d65dadba60"
  #action :install # auto updates itself so we should skip this if it's installed
end

################################################## Local Dpkg ####################################################


# https://askubuntu.com/questions/762462/how-to-install-vidyodesktop-on-ubuntu-16-04-lts
# https://support.vidyocloud.com/hc/en-us/articles/226103528-VidyoDesktop-3-6-3-for-Linux-and-Ubuntu-15-04-and-higher
#package 'libqt4-gui'
# dpkg -i --ignore-depends=libqt4-gui /root/.chef/local-mode-cache/cache/VidyoDesktopInstaller-ubuntu64-TAG_VD_3_6_3_017.deb
vidyo_filename = "VidyoDesktopInstaller-ubuntu64-TAG_VD_3_6_3_017.deb"
vidyo_version = "3.6.3-017"
cookbook_file "#{Chef::Config['file_cache_path']}/#{vidyo_filename}" do
  source vidyo_filename
end

# This libqt4-gui requirement is screwing things up
#dpkg_package 'vidyodesktop' do
#  source "#{Chef::Config['file_cache_path']}/#{vidyo_filename}"
#  version vidyo_version
#end


################################################## Apt Repos #####################################################

apt_repository 'virtualbox' do
  uri 'http://download.virtualbox.org/virtualbox/debian'
  distribution node['lsb']['codename']
  components ['contrib']
  # keyserver 'keyserver.ubuntu.com'
  # key '98AB5139'
  key 'https://www.virtualbox.org/download/oracle_vbox_2016.asc'
end

package 'virtualbox-5.2'

# MANUAL : sudo usermod -a -G vboxusers node['base_user']['username']

# MANUAL : VirtualBox extension pack
# wget http://download.virtualbox.org/virtualbox/5.0.26/Oracle_VM_VirtualBox_Extension_Pack-5.0.26-108824.vbox-extpack
# sudo VBoxManage extpack install ./Oracle_VM_VirtualBox_Extension_Pack-4.2.12-84980.vbox-extpack

apt_repository 'yubico' do
  uri 'ppa:yubico/stable'
  distribution node['lsb']['codename']
end

package 'yubikey-neo-manager'
package 'yubioath-desktop'

apt_repository 'getdeb' do
  uri 'http://archive.getdeb.net/ubuntu'
  distribution 'trusty-getdeb'
  components ['games']
  key '46D7E7CF'
  keyserver 'keyserver.ubuntu.com'
  # MANUAL : vulture-nethack
  # This required manually running 'sudo apt-get update' to prevent the error
  # WARNING: The following packages cannot be authenticated!
  #    vulture-data vulture-nethack
  # STDERR: E: There are problems and -y was used without --force-yes
end

package 'vulture-nethack'

# apt_repository 'vikoadi' do
#   uri 'ppa:vikoadi/ppa'
#   distribution node['lsb']['codename']
# end
# https://github.com/vikoadi/indicator-kdeconnect/issues/43#issuecomment-336427646
apt_repository 'webupd8team-indicator-kdeconnect' do
  uri 'ppa:webupd8team/indicator-kdeconnect'
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
  key 'https://linux-packages.resilio.com/resilio-sync/key.asc'
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

apt_repository 'ansible-ansible' do
  uri 'ppa:ansible/ansible'
  distribution node['lsb']['codename']
end

package 'ansible'

apt_repository 'mixxx-mixxx' do
  uri 'ppa:mixxx/mixxx'
  distribution node['lsb']['codename']
end

package 'mixxx'

apt_repository 'cpick-hub' do
  # https://github.com/github/hub/issues/718
  uri 'ppa:cpick/hub'
  distribution node['lsb']['codename']
end

package 'hub'

# MANUAL : tails-installer depending on Unbuntu distro
# There's no package for 14.04 unfortunately
apt_repository 'tails-team-tails-installer' do
  uri 'ppa:tails-team/tails-installer'
  distribution node['lsb']['codename']
end

package 'tails-installer'

apt_repository 'nilarimogard-webupd8' do
  uri 'ppa:nilarimogard/webupd8'
  distribution node['lsb']['codename']
end

package 'pulseaudio-equalizer'

# https://askubuntu.com/a/765407
apt_repository 'acestream' do
  uri 'http://repo.acestream.org/ubuntu/'
  # distribution node['lsb']['codename']
  distribution 'trusty'
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'E1254F21D636B7EFDE41D2AF50E2BCF0E3805CD8'
end

package %w(acestream-engine)

# https://nodejs.org/en/download/package-manager/
# node (nodejs) and npm in the Ubuntu repos are super old
apt_repository 'nodesource' do
  uri 'https://deb.nodesource.com/node_8.x'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key '9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280'
end

package 'nodejs'

# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04

apt_repository 'docker' do
  uri 'https://download.docker.com/linux/ubuntu'
  distribution node['lsb']['codename']
  components ['stable']
  arch 'amd64'
  key 'https://download.docker.com/linux/ubuntu/gpg'
end

package 'docker-ce'
# TODO : Add user to the docker group, logout and log back in

# https://signal.org/download/
apt_repository 'signal' do
  uri 'https://updates.signal.org/desktop/apt'
  distribution node['lsb']['codename']
  components ['main']
  arch 'amd64'
  key 'https://updates.signal.org/desktop/apt/keys.asc'
end

package 'signal-desktop'

############################################################ Remote Binary ##########################################################

packer_package_filename = "#{Chef::Config['file_cache_path']}/packer_0.12.3_linux_amd64.zip"
remote_file packer_package_filename do
  source 'https://releases.hashicorp.com/packer/0.12.3/packer_0.12.3_linux_amd64.zip'
  checksum 'd11c7ff78f546abaced4fcc7828f59ba1346e88276326d234b7afed32c9578fe'
  notifies :run, 'execute[unzip packer]', :immediately
end

execute "unzip packer" do
  command "unzip #{packer_package_filename} -d /usr/local/bin"
  action :nothing
end

remote_file '/usr/local/bin/docker-compose' do
  source 'https://github.com/docker/compose/releases/download/1.16.1/docker-compose-Linux-x86_64'
  checksum "1804b0ce6596efe707b9cab05d74b161833ed503f0535a937dd5d17bea8fc50a"
  mode "0755"
end

remote_file "/etc/bash_completion.d/docker-compose" do
  source "https://raw.githubusercontent.com/docker/compose/1.16.1/contrib/completion/bash/docker-compose"
  checksum "40d07c7b82d2cb4253c71a8107bcddbe6b7802efb6a8711aa4ec68fa5bdeb8d1"
  mode "0644"
end

terraform_package_filename = "#{Chef::Config['file_cache_path']}/terraform.zip"
remote_file terraform_package_filename do
  source "https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip"
  checksum "6b8ce67647a59b2a3f70199c304abca0ddec0e49fd060944c26f666298e23418"
  notifies :run, 'execute[unzip terraform]', :immediately
end

execute "unzip terraform" do
  command "unzip #{terraform_package_filename} -d /usr/local/bin"
  action :nothing
end

############################################################ Manual Apt Repo ########################################################


# MANUAL : When we upgrade to 16.04 install republicanywhere
# http://www.omgubuntu.co.uk/2017/07/republic-wireless-anywhere-linux


# systemctl mask unattended-upgrades
# https://unix.stackexchange.com/a/369582/22701


############################################################ Python #################################################################

python_runtime '2' do
  provider :system
  version '2.7'
end

python_package 'virtualenvwrapper'
directory "#{base_homedir}/.virtualenvs"
file "#{base_homedir}/.virtualenvs/postmkvirtualenv" do
  content "pip install boto3\n"
end

python_package 'awslogs'
python_package 'bugwarrior'

############################################################ Ruby ###################################################################

gem_package 'chef'

# git : see git.rb

# MANUAL
# jetbrains intellij idea
# pycharm
# webstorm
# rubymine
# phpstorm with snap
# https://www.jetbrains.com/phpstorm/download/#section=linux