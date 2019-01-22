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
  package_name %w(
    alsa-tools-gui
    android-tools-adb
    android-tools-fastboot
    apt-file
    at
    audacious
    audacity
    bsdgames
    bzr
    curl
    dconf-editor
    ddclient
    dos2unix
    dosbox
    dstat
    encfs
    exfat-fuse
    exfat-utils
    flac
    gameconqueror
    gconf-editor
    gimp
    golang
    gparted
    gtkpod
    heimdall-flash
    htop
    httpie
    httping
    idn
    imagemagick
    inkscape
    iotop
    iperf
    ipython
    knockd
    krename
    lame
    lsyncd
    maildir-utils
    mailutils
    mame
    mame-tools
    meld
    mencoder
    minicom
    mkvtoolnix
    moreutils
    mp3diags
    network-manager-openvpn
    network-manager-openvpn-gnome
    nmap
    oathtool
    openshot
    openssh-server
    openvpn
    pandoc
    pitivi
    playonlinux
    powertop
    puddletag
    pwgen
    python-bs4
    python-html2text
    python-matplotlib
    python-yaml
    qreator
    qrencode
    redshift
    redshift-gtk
    ruby
    ruby-dev
    samba
    screen
    secure-delete
    flameshot
    smartmontools
    snmp
    sqlite3
    sshfs
    subversion
    termsaver
    texlive
    tftp
    tftpd
    traceroute
    transmission-remote-gtk
    tree
    tvnamer
    unp
    unrar
    vbrfix
    vlc
    whois
    wireshark
    xinetd
    xsel
    xtightvncviewer
    yubikey-personalization
    yubikey-personalization-gui
    jq
    iftop
    nethogs
    gcc-6-base
    nfs-common
    ffmpeg
    xournal
    gir1.2-gtop-2.0
    gir1.2-networkmanager-1.0
    gir1.2-clutter-1.0
    flashplugin-installer
    colordiff
    calibre
    texlive-extra-utils
    lm-sensors
    autokey-gtk
    mp3info
    gnome-clocks
  )
end

# MANUAL : Disable the print screen key for autokey : https://askubuntu.com/a/279572/14601

if node["platform_version"] == "16.04"
  package "base #{node["platform_version"]} OS packages" do
    package_name %w(
      compizconfig-settings-manager
      sysv-rc-conf
      pdftk
      gksu
      phatch
      mnemonicode
      wine
      task
    )
  end

  # https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1296270
  package "packages to purge in #{node["platform_version"]}" do
    package_name %w(
      myspell-en-au
      myspell-en-gb
      myspell-en-za
      unity-webapps-common
      gnome-screensaver
      gnome-orca
    )
    action :remove
  end
end

if node["platform_version"] == "18.04"
  package "packages to purge in #{node["platform_version"]}" do
    package_name %w(
      ubuntu-web-launchers
    )
    action :remove
  end
  package "base #{node["platform_version"]} OS packages" do
    package_name %w(
      wine-stable
      taskwarrior
      gnome-shell-extensions
      chrome-gnome-shell
    )
  end
end

# heroku : See mozilla.rb

#################################################### Remote Dpkg Files ##########################################################

# https://keybase.io/docs/the_app/linux_expired_key
remote_dpkg 'keybase' do
  source "https://prerelease.keybase.io/keybase_amd64.deb"
  checksum "76333c6c50f797d83237535a429ea8ed7fa986af690d4346060fee0a1a0ce135"
  action :install # keybase auto updates itself so we should skip this if it's installed
  # source "https://dist.keybase.io/linux/deb/keybase-latest-amd64.deb"
  # checksum "0fa9860a0ce77b0507b440115a55c710e53d71eb4d181014f4b7150c341736db"
end

remote_dpkg 'spideroakone' do
  source "https://spideroak.com/release/spideroak/deb_x64"
  filename "spideroakone.deb"
  checksum "6d745db2772feefa4ef80e589b8172c6c396c4e2b68fc4d961dac5661baeddd0"
  action :install # spideroakone auto updates itself so we should skip this if it's installed
end

package ['python-apt',
         'libgl1-mesa-glx:i386']
remote_dpkg 'steam' do
  source "https://steamcdn-a.akamaihd.net/client/installer/steam.deb"
  checksum "cb71d32b7d6e6a7d8c0016db9d8d2d3f95d4f48bc41213190401237e9b482280"
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
  checksum "686c87edee9b06a92bf8b193e2b6a5805e97423a0a67953628b245ded9cf28d9"
  action :install # semaphor auto updates itself so we should skip this if it's installed
end

package 'libapache2-mod-auth-openidc'

package ['python-appindicator',
         'python-appdirs',
         'python-netifaces',
         'python-ipaddr',
         'python-psutil',
         'resolvconf']
remote_dpkg 'mullvad' do
  # source "https://www.mullvad.net/download/latest/linux/"
  # Mullvad 63 introduced depenency on [python-wxgtk3.0](https://packages.ubuntu.com/search?keywords=python-wxgtk3.0) not present in Ubuntu 14.04
  # MANUAL : mullvad depending on Ubuntu distro
  source "https://mullvad.net/media/app/MullvadVPN-2018.6_amd64.deb"
  filename "mullvad_all.deb"
  checksum "00384f8379b7a3a9eb2fef2662f1ae37c8913868e5e0e1282f21601fafa8b79e"
end

package ['libqt4-sql-sqlite']
remote_dpkg 'rescuetime' do
  source "https://www.rescuetime.com/installers/rescuetime_current_amd64.deb"
  checksum "2d8b970f9d0ac73974cf3c2717340702f4beb450a8945263cbd6c375b199e3d3"
  #action :install # auto updates itself so we should skip this if it's installed
end


remote_dpkg 'geogebra5' do
  source "http://www.geogebra.net/linux/pool/main/g/geogebra5/geogebra5_5.0.487.0-636500_amd64.deb"
  checksum "f45fbb3b48ae7cc65f0a7d224583307a029ef40c074e3264e725087a659d47c1"
  action :install # auto updates itself so we should skip this if it's installed
end

if node["platform_version"] == "16.04"
  package ['libqt5clucene5',
           'libqt5designer5',
           'libqt5help5',
           'python3-pyqt5',
           'python3-pyudev',
           'python3-sip']
end
if node["platform_version"] == "18.04"
  package ['python3-pyudev']
end
remote_dpkg 'python3-multibootusb' do
  source "https://github.com/mbusb/multibootusb/releases/download/v8.8.0/python3-multibootusb_8.8.0-1_all.deb"
  checksum "8dd041f99b95a7b5a4140b27c85cbf3af75a14ae4bdf61202a3ca3d65dadba60"
  #action :install # auto updates itself so we should skip this if it's installed
end

# zoom : See mozilla.rb

# MANUAL : pdftk
# Currently pdftk is missing for 18.04
# The workaround is to install manually like this : https://bugs.launchpad.net/ubuntu/+source/pdftk/+bug/1764450/comments/4
# Preceded by
# apt install gcc-6-base libpython-stdlib python python-minimal python2.7 python2.7-minimal
#

################################################## Local Dpkg ####################################################


# To work around the libqt4-gui problem I've followed these guidelines and produced a new deb file
# https://askubuntu.com/questions/762462/how-to-install-vidyodesktop-on-ubuntu-16-04-lts
# https://support.vidyocloud.com/hc/en-us/articles/226103528-VidyoDesktop-3-6-3-for-Linux-and-Ubuntu-15-04-and-higher
#package 'libqt4-gui'
# dpkg -i --ignore-depends=libqt4-gui /root/.chef/local-mode-cache/cache/VidyoDesktopInstaller-ubuntu64-TAG_VD_3_6_3_017.deb
#vidyo_filename = "VidyoDesktopInstaller-ubuntu64-TAG_VD_3_6_3_017.deb"


# https://bugzilla.mozilla.org/show_bug.cgi?id=701083#c127
if node["platform_version"] == "18.04"
  package "stalonetray"
  # TODO : enable stalonetray by creating a systemctl service thing to launch it or something
  # stalonetray -geometry +80+32 &
end


vidyo_filename = "VidyoDesktopInstaller-ubuntu64-TAG_VD_3_3_0_027-no-libqt4-gui-dependency.deb"
vidyo_version = "3.6.3-017"
cookbook_file "#{Chef::Config['file_cache_path']}/#{vidyo_filename}" do
  source vidyo_filename
end

# Vidyo : See mozilla.rb

# https://bugzilla.mozilla.org/show_bug.cgi?id=701083#c98
file '/etc/xdg/autostart/VidyoDesktop.desktop' do
  action :delete
end

# https://github.com/bitwarden/browser/issues/580#issuecomment-387456254
# https://github.com/ibus/ibus/issues/2002#issuecomment-396711051
# https://bugzilla.mozilla.org/show_bug.cgi?id=1405634#c16
# https://bugzilla.mozilla.org/attachment.cgi?id=8974077
ibus_filename = "ibus-gtk3_1.5.17-3ubuntu4_amd64.deb"
cookbook_file "#{Chef::Config['file_cache_path']}/#{ibus_filename}" do
  source ibus_filename
end

dpkg_package 'ibus-gtk3' do
  source "#{Chef::Config['file_cache_path']}/#{ibus_filename}"
  # not_if "dpkg -s #{@name}"
  not_if { ::File.size?('/usr/lib/x86_64-linux-gnu/gtk-3.0/3.0.0/immodules/im-ibus.so') == 30744 }
  # so we can't do file size comparison because the size doesn't change, nor the version. not sure what to do
  # also it skips installation because it's already installed
end


################################################## Apt Repos #####################################################

apt_repository 'virtualbox' do
  uri 'http://download.virtualbox.org/virtualbox/debian'
  distribution node['lsb']['codename']
  components ['contrib']
  arch 'amd64' # https://askubuntu.com/a/1029865/14601
  key 'B9F8D658297AF3EFC18D5CDFA2F683C52980AECF'
  # key 'https://www.virtualbox.org/download/oracle_vbox_2016.asc'
end

package 'virtualbox-6.0'

# MANUAL : sudo usermod -a -G vboxusers node['base_user']['username']

# MANUAL : VirtualBox extension pack
# wget http://download.virtualbox.org/virtualbox/5.0.26/Oracle_VM_VirtualBox_Extension_Pack-5.0.26-108824.vbox-extpack
# sudo VBoxManage extpack install ./Oracle_VM_VirtualBox_Extension_Pack-4.2.12-84980.vbox-extpack

apt_repository 'yubico' do
  uri 'ppa:yubico/stable'
  distribution node['lsb']['codename']
end

package ['yubikey-manager',
         'yubikey-manager-qt',
         'yubioath-desktop']

package 'yubikey-neo-manager'
package 'yubioath-desktop'

apt_repository 'getdeb' do  # vulture-nethack
  # http://www.webupd8.org/2010/05/getdeb-playdeb-repositories-down-what.html
  # uri 'http://archive.getdeb.net/ubuntu'
  uri 'http://mirrors.dotsrc.org/getdeb/ubuntu'
  distribution 'trusty-getdeb'
  components ['games']
  # key 'http://archive.getdeb.net/getdeb-archive.key'
  key '1958A549614CE21CFC27F4BAA8A515F046D7E7CF'
  # MANUAL : vulture-nethack
  # This required manually running 'sudo apt-get update' to prevent the error
  # WARNING: The following packages cannot be authenticated!
  #    vulture-data vulture-nethack
  # STDERR: E: There are problems and -y was used without --force-yes
end
if node["platform_version"] == "18.04"
  # https://www.linuxuprising.com/2018/05/fix-libpng12-0-missing-in-ubuntu-1804.html
  remote_dpkg 'libpng12-0' do
    source "http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb"
    checksum "1644e3936830ed3cf3ab7fac64de99f38e16f7be001ce7947600789ce85e7bcc"
  end
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

# TODO : Consider using this fork of kdeconnect instead?
# https://github.com/Bajoja/indicator-kdeconnect

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

# Disabling for the time being as I'm not using btsync much other than kalx
# http://blog.bittorrent.com/2016/02/18/official-linux-packages-for-sync-now-available/
# apt_repository 'btsync' do
#   uri 'http://linux-packages.getsync.com/btsync/deb'
#   distribution 'btsync'
#   components ['non-free']
#   key 'https://linux-packages.resilio.com/resilio-sync/key.asc'
# end
#
# package "btsync"

if node["platform_version"] == "16.04"
  # There's no version of this for 18.04 from https://github.com/davewongillies
  apt_repository 'daveg-attract' do
    uri 'ppa:daveg/attract'
    distribution node['lsb']['codename']
  end

  package 'attract'
end

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

if node["platform_version"] == "16.04"
  apt_repository 'shutter-ppa' do
    uri 'ppa:shutter/ppa'
    distribution node['lsb']['codename']
  end

  package 'shutter'
end

if node["platform_version"] == "18.04"
  # Looks 18.04 comes with shutter
  # http://ubuntuhandbook.org/index.php/2018/04/fix-edit-option-disabled-shutter-ubuntu-18-04/
  # http://shutter-project.org/downloads/
  # https://itsfoss.com/shutter-edit-button-disabled/

  package "libextutils-depends-perl"
  package "libextutils-pkgconfig-perl"

  remote_dpkg 'libgoocanvas-common' do
    source "https://launchpad.net/ubuntu/+archive/primary/+files/libgoocanvas-common_1.0.0-1_all.deb"
    checksum "067cb55ea73bd4445e2115ae46982f6874fcb9fcefd1dba66b50b647cb3d6b64"
    action :install # auto updates itself so we should skip this if it's installed
  end

  remote_dpkg 'libgoocanvas3' do
    source "https://launchpad.net/ubuntu/+archive/primary/+files/libgoocanvas3_1.0.0-1_amd64.deb"
    checksum "d6329b2d89d728d6d00128fae707544880fb6b864aaac078f85eac20f85eb04c"
    not_if "dpkg -s #{@name}"
  end

  package "libgoo-canvas-perl dependencies" do
    package_name %w(
      libgtk2-perl
      libpango-perl
  )
  end
  remote_dpkg 'libgoo-canvas-perl' do
    source "https://launchpad.net/ubuntu/+archive/primary/+files/libgoo-canvas-perl_0.06-2ubuntu3_amd64.deb"
    checksum "15f70008852e946fe2e32c23f2d238d044eecd07bd2fff02fa93a0ce3c7d1ac1"
    not_if "dpkg -s #{@name}"
  end
  package "shutter"
end

# https://github.com/eosrei/emojione-color-font
# This causes a known issue with Firefox
# https://github.com/eosrei/emojione-color-font/issues/51#issuecomment-239117267
# https://github.com/eosrei/emojione-color-font#known-issues
# https://bugzilla.mozilla.org/show_bug.cgi?id=1245811
# https://github.com/eosrei/emojione-color-font/issues/31
# That must be worked around in Firefox by setting about:config
# gfx.font_rendering.fontconfig.fontlist.enabled : False
apt_repository 'eosrei-fonts' do
  uri 'ppa:eosrei/fonts'
  distribution node['lsb']['codename']
end

package 'fonts-twemoji-svginot'

apt_repository 'ansible-ansible' do
  uri 'ppa:ansible/ansible'
  distribution node['lsb']['codename']
end

package 'ansible'

apt_repository 'mixxx-mixxx' do
  uri 'ppa:mixxx/mixxx'
  distribution node['lsb']['codename']
end

# Now that this bug is fixed https://bugs.launchpad.net/mixxx/+bug/1532631 I can re-enable mixxx
package 'mixxx'

apt_repository 'cpick-hub' do
  # https://github.com/github/hub/issues/718
  uri 'ppa:cpick/hub'
  distribution node['lsb']['codename']
end

package 'hub'

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

if node["platform_version"] == "16.04"
  # https://askubuntu.com/a/765407
  apt_repository 'acestream' do
    uri 'http://repo.acestream.org/ubuntu/'
    # distribution node['lsb']['codename']
    distribution 'trusty'
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    # When adding this key with chef I get an error but doing it manually works. Huh not sure.
    key 'E1254F21D636B7EFDE41D2AF50E2BCF0E3805CD8'
  end
  package %w(acestream-engine)
end

if node["platform_version"] == "18.04"
  snap "acestreamplayer"

  # https://askubuntu.com/a/1064838/14601
  snap "gnome-system-monitor" do
    action :remove
  end
  package "gnome-system-monitor"
end

# https://nodejs.org/en/download/package-manager/
# node (nodejs) and npm in the Ubuntu repos are super old
apt_repository 'nodesource' do
  uri 'https://deb.nodesource.com/node_8.x'
  distribution node['lsb']['codename']
  components ['main']
  key '9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280'
end

package 'nodejs'

# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04

apt_repository 'docker' do
  uri 'https://download.docker.com/linux/ubuntu'
  distribution node['lsb']['codename']
  components ['stable']
  arch 'amd64'
  # key 'https://download.docker.com/linux/ubuntu/gpg'
  key '9DC858229FC7DD38854AE2D88D81803C0EBFCD88'
end

package 'docker-ce'
# TODO : Add user to the docker group, logout and log back in

# https://signal.org/download/
apt_repository 'signal' do
  uri 'https://updates.signal.org/desktop/apt'
  # distribution node['lsb']['codename']
  # This isn't yet available for bionic 18.04 so we'll force it to xenial 16.04
  distribution "xenial"
  components ['main']
  arch 'amd64'
  # key 'https://updates.signal.org/desktop/apt/keys.asc'
  key 'DBA36B5181D0C816F630E889D980A17457F6FB06'
end

package 'signal-desktop'

# We're installing this from ppa because it's missing from 18.04. It's present in 16.04 though
apt_repository 'gezakovacs-ppa' do
  uri 'ppa:gezakovacs/ppa'
  distribution node['lsb']['codename']
end
package 'unetbootin'

# https://mkvtoolnix.download/downloads.html#ubuntu
apt_repository 'mkvtoolnix' do
  uri 'https://mkvtoolnix.download/ubuntu/'
  distribution node['lsb']['codename']
  components ['main']
  arch 'amd64'
  # key 'https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt'
  key 'D9199745B0545F2E8197062B0F92290A445B9007'
end

package "mkvtoolnix tools" do
  package_name %w(
    mkvtoolnix
    mkvtoolnix-gui
  )
end

# This didn't work Workaround for inability to suspend
# https://askubuntu.com/a/1038528/14601
# https://people.canonical.com/~khfeng/lp1774950/
# https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1774950?comments=all
# apt_repository 'teejee2008-ppa' do
#   uri 'ppa:teejee2008/ppa'
#   distribution node['lsb']['codename']
# end
# package 'ukuu'
# package 'libelf-dev'  # I'm seeing errors from vboxdrv.service in /var/log/vbox-setup.log when booting from the 4.14 kernel indicating this is needed


############################################################ Remote Binary ##########################################################

packer_package_filename = "#{Chef::Config['file_cache_path']}/packer.zip"
remote_file packer_package_filename do
  source 'https://releases.hashicorp.com/packer/1.2.4/packer_1.2.4_linux_amd64.zip'
  checksum '258d1baa23498932baede9b40f2eca4ac363b86b32487b36f48f5102630e9fbb'
  notifies :run, 'execute[unzip packer]', :immediately
end

execute "unzip packer" do
  command "unzip #{packer_package_filename} -d /usr/local/bin"
  action :nothing
end

remote_file '/usr/local/bin/docker-compose' do
  source 'https://github.com/docker/compose/releases/download/1.21.2/docker-compose-Linux-x86_64'
  checksum '8a11713e11ed73abcb3feb88cd8b5674b3320ba33b22b2ba37915b4ecffdf042'
  mode "0755"
end

remote_file "/etc/bash_completion.d/docker-compose" do
  source "https://raw.githubusercontent.com/docker/compose/1.21.2/contrib/completion/bash/docker-compose"
  checksum '618ef7a88b4090a5e5708b5f44b18b3c811d8d6c98465977aa64fde39c6e7455'
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

# https://rtyley.github.io/bfg-repo-cleaner/
remote_file "/usr/local/bin/bfg-1.13.0.jar" do
  source "http://repo1.maven.org/maven2/com/madgag/bfg/1.13.0/bfg-1.13.0.jar"
  # checksum '5cec8b883c26f00e45f472c6024f4d367e555c8f48956220bdb16f0298798452'
  mode "0644"
end

link "/usr/local/bin/bfg.jar" do
  to "/usr/local/bin/bfg-1.13.0.jar"
end

############################################################ Manual Apt Repo ########################################################


# systemctl mask unattended-upgrades
# https://unix.stackexchange.com/a/369582/22701


############################################################ Python #################################################################

python_runtime '2' do
  provider :system
  version '2.7'
  pip_version '10.0.1'
  get_pip_url 'https://raw.githubusercontent.com/pypa/get-pip/04e994a41ff0a97812d6d25443318ef268bc2bca/3.3/get-pip.py'
end

python_package 'virtualenvwrapper'
directory "#{base_homedir}/.virtualenvs" do
  owner node['base_user']['username']
  group node['base_user']['username']
end
file "#{base_homedir}/.virtualenvs/postmkvirtualenv" do
  content "pip install boto3\n"
  owner node['base_user']['username']
  group node['base_user']['username']
end

python_package 'awslogs'
python_package 'bugwarrior'
python_package 'fork-github-repo'
python_package 'youtube-dl'
python_package 'pipenv'

############################################################ Ruby ###################################################################

# Why did we need to install the chef gem?
# gem_package 'chef'

# git : see git.rb

# MANUAL
# jetbrains intellij idea
# pycharm
# webstorm
# rubymine*
# phpstorm with snap
# https://www.jetbrains.com/phpstorm/download/#section=linux
#
# Packages no longer available
#
# gksu has been removed from Ubuntu https://bugs.launchpad.net/ubuntu/+source/umit/+bug/1740618
# mnemonicode isn't present in Ubuntu 18.04
# phatch depends on python-imaging https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=866449
#   Consider http://converseen.fasterland.net/ instead

# MANUAL
# Gnome Extensions
# https://extensions.gnome.org/extension/1317/alt-tab-switcher-popup-delay-removal/
# https://extensions.gnome.org/extension/826/suspend-button/
#   https://askubuntu.com/a/967207/14601
# https://extensions.gnome.org/extension/120/system-monitor/
#   https://askubuntu.com/a/974204/14601
# TODO : Add Arduino IDE
# /opt/arduino/install.sh
