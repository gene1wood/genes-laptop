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
    action :enable
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
    source 'publicaccess/netatalk/afpd.conf'
    mode '0644'
    notifies :reload, 'service[netatalk]', :delayed
end

template '/etc/default/netatalk' do
    source 'publicaccess/netatalk/netatalk.erb'
    mode '0644'
    variables({
      :username => node['base_user']['username']
    })
    notifies :reload, 'service[netatalk]', :delayed
end

cookbook_file '/etc/netatalk/AppleVolumes.default' do
    source 'publicaccess/netatalk/AppleVolumes.default'
    mode '0644'
    notifies :reload, 'service[netatalk]', :delayed
end

cookbook_file '/etc/nsswitch.conf' do
    source 'nsswitch.conf'
    mode '0644'
end

cookbook_file '/etc/avahi/services/afpd.service' do
    source 'publicaccess/netatalk/afpd.service'
    mode '0644'
    notifies :reload, 'service[avahi-daemon]', :delayed
end

cookbook_file '/etc/ufw/applications.d/afp' do
    source 'publicaccess/ufw/afp'
end


# firewall_rule 'afp' do
#   port     548
#   action   :allow
# end

# TODO test if this works from a mac

service 'samba' do
    action :enable
end

directory '/srv/public/samba' do
    owner 'nobody'
    group 'nogroup'
end

cookbook_file '/etc/samba/smb.conf' do
    source 'publicaccess/smb.conf'
    mode '0644'
    notifies :reload, 'service[samba]', :delayed
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

service 'nfs-kernel-server' do
    action :enable
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
    source 'publicaccess/nfs/nfs-common'
    mode '0644'
    notifies :restart, 'service[nfs-kernel-server]', :delayed
end

cookbook_file '/etc/default/nfs-kernel-server' do
    source 'publicaccess/nfs/nfs-kernel-server'
    mode '0644'
    notifies :restart, 'service[nfs-kernel-server]', :delayed
end

template '/etc/exports' do
    source 'publicaccess/exports.erb'
    mode '0644'
    variables({
      :cidrs => node['nfs']['public']['cidrs']
    })
    notifies :restart, 'service[nfs-kernel-server]', :delayed
end

cookbook_file '/etc/ufw/applications.d/nfs' do
    source 'publicaccess/ufw/nfs'
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
    pass 0
    action [ :enable, :mount ]
end

cookbook_file '/usr/local/bin/publicaccess.sh' do
    source 'publicaccess/publicaccess.sh'
    mode '0755'
end

# TODO 
# webdav
# ftp