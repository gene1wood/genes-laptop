# TODO : Change this to a template that uses node['gpg']['basedir'] and 'default_key'
cookbook_file "#{base_homedir}/.migrc" do
  source 'homedir/.migrc'
  owner node['base_user']['username']
  group node['base_user']['username']
end

# https://devcenter.heroku.com/articles/heroku-cli#download-and-install
snap "heroku" do
  classic true
end
# TODO : Create ~/.netrc file with API keys (possibly GPG encrypted)
# https://devcenter.heroku.com/articles/authentication

package ['libxcb-xtest0']
remote_dpkg 'zoom' do
  source "https://auth0.zoom.us/client/latest/zoom_amd64.deb"
  checksum '90b495b26f1c54363bc06985b808d6dee328822f5123734d742fd12fa9e38695'
end

dpkg_package 'vidyodesktop' do
  source "#{Chef::Config['file_cache_path']}/#{vidyo_filename}"
  version vidyo_version
  not_if "dpkg -s #{@name}"
end

include_recipe 'wendy::crashplan'


# MANUAL : mig-loader
# Disabling this as when it runs it overwrites the config : https://github.com/mozilla/mig/issues/347
# I've also disabled the mig-agent service which the mig-loader installs with
# update-rc.d -f mig-agent remove
#
# cookbook_file "/etc/cron.d/mig-loader" do
#   source 'etc/cron.d/mig-loader'
# end
