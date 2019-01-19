#
# Cookbook Name:: wendy
# Recipe:: firewall
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

firewall_rule 'ssh' do
  port     22
#  notifies :enable, 'firewall[default]'
end

service 'rsyslog'

cookbook_file '/etc/rsyslog.d/20-ufw.conf' do
    source 'rsyslog.d/20-ufw.conf'
    notifies :restart, 'service[rsyslog]', :delayed
end

firewall_rule 'kdeconnect tcp' do
  protocol  :tcp
  port     1714..1764
end

firewall_rule 'kdeconnect udp' do
  protocol  :udp
  port     1714..1764
end

# I don't think we need this anymore
# firewall_rule 'btsync tcp' do
#   protocol  :tcp
#   port     node[:btsync][:port]
# end
#
# firewall_rule 'btsync udp' do
#   protocol  :udp
#   port     node[:btsync][:port]
# end
