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



# sysctl.conf
# fs.inotify.max_user_watches=1048576
# http://support.code42.com/CrashPlan/Latest/Troubleshooting/Linux_Real-Time_File_Watching_Errors

# prereq java
