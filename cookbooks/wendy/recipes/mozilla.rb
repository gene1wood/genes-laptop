# TODO : Change this to a template that uses node['gpg']['basedir'] and 'default_key'
cookbook_file "#{base_homedir}/.migrc" do
  source 'homedir/.migrc'
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