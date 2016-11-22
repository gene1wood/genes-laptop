resource_name :remote_dpkg

property :package_name, String, required: true, name_property: true
property :source, String, required: true # This doesn't really need to be a string
property :checksum, [ /^[a-zA-Z0-9]{64}$/, nil ]
property :filename, String, default: nil

default_action :upgrade

action :upgrade do
  filename = new_resource.filename.nil? ? /.*\/([^\/?#&]*)/.match(new_resource.source)[1] : new_resource.filename
  remote_file "#{Chef::Config['file_cache_path']}/#{filename}" do
    source new_resource.source
    checksum new_resource.checksum
  end

  dpkg_package new_resource.package_name do
    action :upgrade
    source "#{Chef::Config['file_cache_path']}/#{filename}"
  end
end

action :install do
  filename = new_resource.filename.nil? ? /.*\/([^\/?#&]*)/.match(new_resource.source)[1] : new_resource.filename
  remote_file "#{Chef::Config['file_cache_path']}/#{filename}" do
    source new_resource.source
    checksum new_resource.checksum
  end

  dpkg_package new_resource.package_name do
    action :install
    source "#{Chef::Config['file_cache_path']}/#{filename}"
  end
end


action :delete do
  dpkg_package new_resource.package_name do
    action :delete
  end
end