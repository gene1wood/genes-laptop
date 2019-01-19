#
# Cookbook Name:: wendy
# Recipe:: publicaccess
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# http://fixpress.org/afp-ubuntu.html

package 'netatalk'
package 'avahi-daemon'
package 'libnss-mdns'

service 'netatalk' do
    action :disable
end

service 'avahi-daemon' do
    action :enable
end

directory '/srv/public'
directory '/srv/public/afs' do
    owner 'nobody'
    group 'nogroup'
end

cookbook_file '/etc/netatalk/afpd.conf' do
    source name[1..-1]
    mode '0644'
    notifies :restart, 'service[netatalk]', :delayed
end

template '/etc/default/netatalk' do
    source name[1..-1] + '.erb'
    mode '0644'
    variables({
      :username => node['base_user']['username']
    })
    notifies :restart, 'service[netatalk]', :delayed
end

cookbook_file '/etc/netatalk/AppleVolumes.default' do
    source name[1..-1]
    mode '0644'
    notifies :restart, 'service[netatalk]', :delayed
end

cookbook_file '/etc/nsswitch.conf' do
    source name[1..-1]
    mode '0644'
end

cookbook_file '/etc/avahi/services/afpd.service' do
    source name[1..-1]
    mode '0644'
    notifies :reload, 'service[avahi-daemon]', :delayed
end

cookbook_file '/etc/ufw/applications.d/afp' do
    source name[1..-1]
end


# firewall_rule 'afp' do
#   port     548
#   action   :allow
# end

# TODO test if this works from a mac

if node["platform_version"] == "14.04"
  samba_service_name = 'samba' # Ubuntu 14.04
else
  samba_service_name = 'smbd'  # Ubuntu 16.04
end

service samba_service_name do
    action :enable
end

directory '/srv/public/samba' do
    owner 'nobody'
    group 'nogroup'
end

cookbook_file '/etc/samba/smb.conf' do
    source name[1..-1]
    mode '0644'
    notifies :reload, "service[#{samba_service_name}]", :delayed
end

# Based off /etc/ufw/applications.d/samba
# firewall_rule 'samba-udp' do
#   protocol  :udp
#   port     [137, 138]
#   action   :allow
# end

# Based off /etc/ufw/applications.d/samba
# firewall_rule 'samba-tcp' do
#   port     [139, 445]
#   action   :allow
# end

#TODO should I block ipv6

package 'nfs-kernel-server'

service 'nfs-server' do
    action :disable
end

directory '/srv/public/nfs' do
    owner 'nobody'
    group 'nogroup'
end

directory '/export'
directory '/export/public'

directory '/srv/public/nfs' do
    owner 'nobody'
    group 'nogroup'
end

cookbook_file '/etc/default/nfs-common' do
    source name[1..-1]
    mode '0644'
    notifies :restart, 'service[nfs-server]', :delayed
end

cookbook_file '/etc/default/nfs-kernel-server' do
    source name[1..-1]
    mode '0644'
    notifies :restart, 'service[nfs-server]', :delayed
end

template '/etc/exports' do
    source name[1..-1] + '.erb'
    mode '0644'
    variables({
      :cidrs => node['nfs']['public']['cidrs']
    })
    notifies :restart, 'service[nfs-server]', :delayed
end

cookbook_file '/etc/ufw/applications.d/nfs' do
    source name[1..-1]
end

# firewall_rule 'nfs-tcp' do
#   port     [ 111, 2049, 32765, 32766, 32767 ]
#   action   :allow
# end

# firewall_rule 'nfs-udp' do
#   protocol :udp
#   port     [ 111, 2049, 32765, 32766, 32767 ]
#   action   :allow
# end

mount '/export/public' do
    options 'bind'
    device '/srv/public/nfs'
    pass 0  # When the value is 0 for UFS file systems, the file system is not checked by fsck.
    action :enable
end

cookbook_file '/usr/local/bin/publicaccess.sh' do
    source name[1..-1]
    mode '0755'
end

cookbook_file '/usr/local/bin/move_all_public_files_to_gene_scans' do
    source name[1..-1]
    mode '0755'
end

# TODO
# webdav
# ftp