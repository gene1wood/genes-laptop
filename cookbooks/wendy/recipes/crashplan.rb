#
# Cookbook Name:: wendy
# Recipe:: crashplan
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

for crashplan_installation in node[:crashplan] do
    crashplan crashplan_installation[:name] do
        source crashplan_installation[:source]
        checksum crashplan_installation[:checksum]
        type crashplan_installation[:type]
        enabled crashplan_installation[:enabled]
    end
end

cookbook_file "/etc/bash_completion.d/crashplandesktop_wrapper" do
    source 'crashplan/crashplandesktop_wrapper_autocomplete'
    mode '0644'
end

cookbook_file "/usr/local/bin/CrashPlanDesktop_Wrapper" do
    source 'crashplan/CrashPlanDesktop_Wrapper'
    mode '0755'
end

# TODO : Move default 'sysctl.d/61-crashplan-inotify-watches.conf' to here
# sysctl.conf
# fs.inotify.max_user_watches=1048576
# http://support.code42.com/CrashPlan/Latest/Troubleshooting/Linux_Real-Time_File_Watching_Errors

# prereq java

cookbook_file '/etc/sysctl.d/61-crashplan-inotify-watches.conf' do
    source 'sysctl.d/61-crashplan-inotify-watches.conf'
    notifies :start, 'service[procps]', :immediately
end
