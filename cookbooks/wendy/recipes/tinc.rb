#
# Cookbook Name:: wendy
# Recipe:: tinc
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'tinc'

service 'tinc' do
    action :enable
end

directory '/etc/tinc/vpn'

directory '/etc/tinc/vpn/hosts'

template '/etc/tinc/vpn/tinc.conf' do 
    source 'tinc/tinc.conf.erb'
    variables({
        :hostname => node['hostname'],
        :peers    => node['tinc']['peers']
    })
    notifies :reload, 'service[tinc]', :delayed
end

file "/etc/default/tinc" do
    content "# Extra options to be passed to tincd.\nEXTRA=\"--logfile=/var/log/tinc.log\"\n"
    notifies :reload, 'service[tinc]', :delayed
end

file "/etc/tinc/vpn/hosts/#{node['hostname']}" do
    content "Subnet = #{node['tinc']['ip']}/32"
    notifies :reload, 'service[tinc]', :delayed
end

file "/etc/tinc/nets.boot" do
    content <<-EOF
    ## This file contains all names of the networks to be started on system startup.
    vpn
    EOF
    notifies :reload, 'service[tinc]', :delayed
end

file "/etc/tinc/vpn/rsa_key.priv" do
    content node['tinc']['private_key']
    mode '0600'
    notifies :reload, 'service[tinc]', :delayed
end

node['tinc']['peers'].each do |peer|
    template "/etc/tinc/vpn/hosts/#{peer['name']}" do
        source 'tinc/peer.erb'
        variables({
            :peer => peer
        })
        notifies :reload, 'service[tinc]', :delayed
    end
end

template '/etc/tinc/vpn/tinc-up' do 
    source 'tinc/tinc-up.erb'
    variables({
        :ip => node['tinc']['ip']
    })
    mode '0755'
    notifies :reload, 'service[tinc]', :delayed
end

template '/etc/tinc/vpn/tinc-down' do 
    source 'tinc/tinc-down.erb'
    mode '0755'
    notifies :reload, 'service[tinc]', :delayed
end
