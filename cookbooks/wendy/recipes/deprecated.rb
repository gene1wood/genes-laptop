# Disabled packages for 16.04
#    icedtea-7-plugin
#    openjdk-7-jdk
#    avidemux
#    php5-cli
#    libavcodec-extra
#    libavcodec-extra-56
#    libav-tools

# include_recipe 'wendy::eclipse' # I don't use eclipse anymore
# include_recipe 'wendy::crashplan'  # With crashplan person going away, I think I just need corp installed by hand


remote_dpkg 'irccloud-desktop' do
  source 'https://github.com/irccloud/irccloud-desktop/releases/download/v0.3.0/irccloud-desktop-0.3.0-amd64.deb'
  checksum 'f97b6c5b9d972d46431b9ea3fbc0ad5f7ab4f1b082b8c803bdad3ad9e779385e'
end

directory "#{base_homedir}/.config/IRCCloud"

# https://github.com/irccloud/irccloud-desktop/issues/41#issuecomment-247166781
cookbook_file "#{base_homedir}/.config/IRCCloud/config.json" do
  source 'irccloud.config.json'
  owner node['base_user']['username']
  group node['base_user']['username']
end

# I'm not using nomachine anymore
# remote_dpkg 'nomachine' do
#   source "http://download.nomachine.com/download/5.1/Linux/nomachine_5.1.26_1_amd64.deb"
#   checksum "924a2a1f67bc9e1d7c1d5bae2764bd790632a0af5c811cd8e56f1637de7be8f7"
#   action :install # nomachine auto updates itself so we should skip this if it's installed
# end

# file '/etc/init/nxserver.override' do
#   content "# https://www.nomachine.com/TR01N06343\nmanual\n"
# end

# I'm using tvnamer now instead of filebot
# remote_dpkg 'filebot' do
#   source "https://cytranet.dl.sourceforge.net/project/filebot/filebot/FileBot_4.7.9/filebot_4.7.9_amd64.deb"
#   checksum "892723dcec8fe5385ec6665db9960e7c1a88e459a60525c02afb7f1195a50523"
# end


# I don't need puppet agent installed
# remote_dpkg 'puppetlabs-release-pc1' do
#   source "https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb"
#   checksum "e2fbde01e643dead0a8f9aaabd2c8bf09ccaeaf469a192bc2d0fbdbf611230ea"
#   action :install # auto updates itself so we should skip this if it's installed
# end
#
# package 'puppet-agent'

# I don't need rabitvcs I'll stop using it
# apt_repository 'rabbitvcs' do
#   uri 'ppa:rabbitvcs/ppa'
#   distribution node['lsb']['codename']
# end
#
# package 'rabbitvcs-nautilus3'

# I don't have spotify anymore
# apt_repository 'spotify' do
#   uri 'http://repository.spotify.com'
#   distribution 'stable'
#   components ['non-free']
#   keyserver 'keyserver.ubuntu.com'
#   key 'BBEBDCB318AD50EC6865090613B00F1FD2C19886'
# end
#
# package 'spotify-client'

# MANUAL : mig
# Disabling this as when it runs it overwrites the config : https://github.com/mozilla/mig/issues/347
# remote_dpkg 'mig-loader' do
#   source "https://s3.amazonaws.com/infosec-mig/public/it-ws/mig-loader_20160817-0.e43ead4.prod_amd64.deb"
#   checksum "d1f82cced747275536a5ccd7e73b41655e71c493d40d2d9e56bf412a57231dcc"
#   action :install # mig-loader auto updates itself so we should skip this if it's installed
# end

# This has unmet dependencies under 16.04 that I'm having trouble with
#remote_dpkg 'google-earth-stable' do
#  source "https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb"
#  # checksum "924a2a"
#  action :install # this auto updates itself so we should skip this if it's installed
#end

# Only needed for Ubuntu 14.04 and later
#package 'libhiredis0.10'
#remote_dpkg 'libcjose0' do
#  source "https://github.com/pingidentity/mod_auth_openidc/releases/download/v2.2.0/libcjose0_0.4.1-1.trusty.1_amd64.deb"
#  checksum "b7c1238589ff618b27f2e602066706f6851448b4b47d8f8cf5c41345c8acb19c"
#end
#remote_dpkg 'libapache2-mod-auth-openidc' do
#  source "https://github.com/pingidentity/mod_auth_openidc/releases/download/v2.2.0/libapache2-mod-auth-openidc_2.2.0-1.trusty.1_amd64.deb"
#  checksum "42a2439ac3173e21e513df9c8603a73549cb7060020d1ec78b13c1ec8ff01880"
#end

# Don't think we need this in 16.04
# http://askubuntu.com/a/783983/14601
# apt_repository 'heyarje-libav-11' do
#   uri 'ppa:heyarje/libav-11'
#   distribution node['lsb']['codename']
# end
# package 'libav-tools'

# # https://www.torproject.org/docs/debian.html.en
# apt_repository 'torproject' do
#   uri 'http://deb.torproject.org/torproject.org'
#   distribution node['lsb']['codename']
#   components ['main']
#   key 'A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89'
# end
#
# package 'torbrowser' do
#   package_name 'tor', 'deb.torproject.org-keyring'
# end

# directory '/opt/torbrowser'
#
# torbrowser_package_filename = "#{Chef::Config['file_cache_path']}/tor-browser.tar.xz"
# remote_file torbrowser_package_filename do
#   source 'https://www.torproject.org/dist/torbrowser/7.5/tor-browser-linux64-7.5_en-US.tar.xz'
#   # checksum 'd11c7ff78f546abaced4fcc7828f59ba1346e88276326d234b7afed32c9578fe'
#   notifies :run, 'execute[untar torbrowser]', :immediately
# end
#
# execute "untar torbrowser" do
#   command "tar -xvJf #{torbrowser_package_filename} --directory /opt/torbrowser --strip-components=1"
#   action :nothing
# end


# Lets handle these within the Firefox profile instead
# remote_file "/usr/lib/firefox-addons/distribution/extensions/support@lastpass.com.xpi" do
#   # This will only install lastpass on new Firefox profiles, not existing profiles
#   source "https://lastpass.com/download/cdn/lp4.xpi"
#   checksum 'e28cb6d57aa26ecc6be25e58ecc1f12bf7da8b0dcd4680541f68984c7b613219' # 4.0
#   # checksum 'e4b5d91ea880f88d8f5fa3f4d35e377b5144f665c5d037ecb9807d30100f1bfb' # 3.2.16
# end

# remote_file "/usr/lib/firefox-addons/distribution/extensions/uBlock0@raymondhill.net.xpi" do
#   # This will only install ublock origin on new Firefox profiles, not existing profiles
#   source "https://github.com/gorhill/uBlock/releases/download/1.0.0.0/uBlock0.firefox.xpi"
#   checksum 'b586dea639524752fdfd81901ce7ff247955df0f8bc094fd00484175c5fb452b' # 1.0.0.0
# end
