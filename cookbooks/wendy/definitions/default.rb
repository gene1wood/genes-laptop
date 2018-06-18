#
# Cookbook Name:: wendy
# Definition:: crashplan
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

define :crashplan, :name => 'crashplan', 
                   :source => 'https://download.code42.com/installs/linux/install/CrashPlan/CrashPlan_4.3.0_Linux.tgz',
                   :checksum => nil,
                   :type => 'CONSUMER',
                   :config_version => '3',
                   :enabled => true do
    # https://download.code42.com/installs/linux/install/CrashPlan/CrashPlan_4.3.0_Linux.tgz
    # https://download.code42.com/installs/linux/install/CrashPlan/CrashPlan_4.4.1_Linux.tgz

    ENTERPRISE_COOKBOOK_FILENAME = 'crashplan/CrashPlanPROe_4.5.2_Linux.tgz'
    ENTERPRISE_COOKBOOK_CHECKSUM = 'a24be9bc5adde7d012c562064fb885ef23e23dfb078329cd061a55dff091d975'
    ENTERPRISE_CONFIG_VERSION = '7'

    crashplan_install_dir = "/usr/local/#{params[:name]}"
    crashplan_manifest_dir = "/usr/local/var/#{params[:name]}"
    checksum = params[:type] == 'ENTERPRISE' ? ENTERPRISE_COOKBOOK_CHECKSUM : params[:checksum]

    directory crashplan_install_dir
    directory '/usr/local/var'
    directory crashplan_manifest_dir
    directory "#{Chef::Config['file_cache_path']}/#{params[:name]}-#{checksum}"

    if params[:type] == 'ENTERPRISE'
      config_version = ENTERPRISE_CONFIG_VERSION
      cookbook_file "#{Chef::Config['file_cache_path']}/#{params[:name]}.tgz" do
        source ENTERPRISE_COOKBOOK_FILENAME
        notifies :run, "execute[unpack #{params[:name]}]", :immediately
      end
    else
      config_version = params[:config_version]
      remote_file "#{Chef::Config['file_cache_path']}/#{params[:name]}.tgz" do
        source params[:source]
        checksum checksum
        notifies :run, "execute[unpack #{params[:name]}]", :immediately
      end
    end


    execute "unpack #{params[:name]}" do
      command ['tar',
              '--extract',
              '--no-same-owner',
              '--gunzip',
              "--file \"#{Chef::Config['file_cache_path']}/#{params[:name]}.tgz\"",
              "--directory \"#{Chef::Config['file_cache_path']}/#{params[:name]}-#{checksum}\"",
              '--strip-components 1'
              ].join(" ")
      action :nothing
      notifies :run, "bash[install #{params[:name]}]", :immediately
    end

    bash "install #{params[:name]}" do
      cwd crashplan_install_dir
      code <<-EOH
        cat "#{Chef::Config['file_cache_path']}/#{params[:name]}-#{checksum}/"*_*.cpi | gzip -d -c - | cpio -i --no-preserve-owner
        chmod 777 log
        cp --preserve "#{Chef::Config['file_cache_path']}/#{params[:name]}-#{checksum}/scripts/"* bin/
        EOH
      action :nothing
    end

    template "#{crashplan_install_dir}/conf/default.service.xml" do
      source 'crashplan/default.service.xml.erb'
      mode '0644'
      variables({
          :manifest_dir => crashplan_manifest_dir,
          :config_version  => config_version,
          :install_type => params[:type]
      })
    end

    # source crashplan-install/scripts/crashplan
    template "/etc/init.d/#{params[:name]}" do
      source 'crashplan/crashplan.init.erb'
      mode '0755'
      variables({
          :crashplan_install_dir => crashplan_install_dir
      })
    end

    template "#{crashplan_install_dir}/install.vars" do
      source 'crashplan/install.vars.erb'
      variables({
          :crashplan_install_dir => crashplan_install_dir,
          :crashplan_manifest_dir => crashplan_manifest_dir,
          :name => params[:name]
      })
    end

    # source crashplan-install/scripts/CrashPlanEngine
    cookbook_file "#{crashplan_install_dir}/bin/CrashPlanEngine" do
      source 'crashplan/CrashPlanEngine'
      mode '0755'
    end

    # source crashplan-install/scripts/CrashPlanDesktop
    cookbook_file "#{crashplan_install_dir}/bin/CrashPlanDesktop" do
      source 'crashplan/CrashPlanDesktop'
      mode '0755'
    end

    # source crashplan-install/scripts/run.conf
    cookbook_file "#{crashplan_install_dir}/bin/run.conf" do
      source 'crashplan/run.conf'
      mode '0755'
    end

    cookbook_file "/usr/local/bin/CrashPlanDesktop_Wrapper" do
      source 'crashplan/CrashPlanDesktop_Wrapper'
      mode '0755'
    end

    service "#{params[:name]}" do
      # init_command "/etc/init.d/#{params[:name]}"
      action params[:enabled] ? [:enable, :start] : [:disable, :stop]
    end

    # source crashplan-install/scripts/CrashPlan.desktop
    template "#{Chef::Config['file_cache_path']}/#{params[:name]}.desktop" do
      source 'crashplan/crashplan.desktop.erb'
      mode '0644'
      variables({
          :name => params[:name],
          :bin_filename => "#{crashplan_install_dir}/bin/CrashPlanDesktop",
          :icon_filename => "#{crashplan_install_dir}/skin/icon_app_128x128.png"
      })
      notifies :run, "execute[install #{params[:name]} desktop entry]", :immediately
    end

    execute "install #{params[:name]} desktop entry" do
      command "/usr/bin/desktop-file-install --dir=/usr/share/applications \"#{Chef::Config['file_cache_path']}/#{params[:name]}.desktop\""
      action :nothing
    end

end
