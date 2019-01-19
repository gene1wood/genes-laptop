service 'procps'
cookbook_file '/etc/sysctl.d/60-disable-ipv6.conf' do
  source name[1..-1]
  notifies :start, 'service[procps]', :immediately
end

cookbook_file '/etc/default/grub' do
  source name[1..-1]
  notifies :run, 'execute[update-grub]', :immediately
end

execute 'update-grub' do
  action :nothing
end

cookbook_file '/etc/fuse.conf' do
  source name[1..-1]
end

# Original intent was to disable discovering printers with avahi, but that didn't work so this doesn't do anything now
service 'avahi-daemon'
cookbook_file "/etc/avahi/avahi-daemon.conf" do
  source name[1..-1]
  notifies :restart, 'service[avahi-daemon]', :delayed
end

# I'd disabled this for some reason, not sure why
# if this causes a problem again, note why here
# I'm going to disable this on judy 18.04 for now and see if there's a problem without it
# cookbook_file "/usr/lib/pm-utils/sleep.d/45disablelidwakeup" do
#   source name[1..-1]
#   mode '0755'
# end
# https://wiki.archlinux.org/index.php/Power_management#Sleep_hooks

# Register dynamic DNS name
template "/etc/ddclient.conf" do
  source name[1..-1] + ".erb"
  mode '0600'
  variables({
                :domain_name => node['nsupdate.info']['domain_name'],
                :password => node['nsupdate.info']['password']
            })
end

# Allows Mixxx to access HID and USB Bulk controllers when running as a normal user
# https://github.com/mixxxdj/mixxx/commit/56b8e3fb9e08a0b1b3b474aeef11eef4d7d37079#diff-d67062afe8552f2877ec13584f22cec9
cookbook_file "/lib/udev/rules.d/60-mixxx-usb.rules" do
  source name[1..-1]
end

# Prevent lid close from suspending system
# http://tipsonubuntu.com/2018/04/28/change-lid-close-action-ubuntu-18-04-lts/
service 'systemd-logind'
cookbook_file '/etc/systemd/logind.conf' do
  source name[1..-1]
  notifies :restart, 'service[systemd-logind]', :delayed
  # TODO : It's possible restarting systemd-logind kicks the current user out (logs them out)
end

# Fix suspend resume
# https://www.dell.com/community/Inspiron/Suspend-resume-problems-on-Ubuntu-18-04/m-p/6132748/highlight/true#M26976
service "nvidia-fallback" do
  action :disable
end

# Increase log retention
cookbook_file "/etc/logrotate.d/apt" do
  source name[1..-1]
end

# Increase log retention
cookbook_file "/etc/logrotate.d/dpkg" do
  source name[1..-1]
end

# Prevent auto adding printers
# https://www.scivision.co/stop-ubuntu-printer-added-on-network-connect/
service "cups"
cookbook_file "/etc/cups/cups-browsed.conf" do
  source name[1..-1]
  notifies :restart, 'service[cups]', :delayed
end
