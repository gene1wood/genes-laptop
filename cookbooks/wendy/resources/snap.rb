resource_name :snap

property :package_name, String, required: true, name_property: true

default_action :install

action :upgrade do
  execute "snap install #{new_resource.package_name}" do
    not_if "snap list #{new_resource.package_name}"
  end
  execute "snap refresh #{new_resource.package_name}"
end

action :install do
  execute "snap install #{new_resource.package_name}" do
    not_if "snap list #{new_resource.package_name}"
  end
end

action :remove do
  execute "snap remove #{new_resource.package_name}" do
    only_if "snap list #{new_resource.package_name}"
  end
end
