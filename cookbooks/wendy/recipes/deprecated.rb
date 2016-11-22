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

