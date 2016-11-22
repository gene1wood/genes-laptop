directory '/var/lib/btsync/share/' do
  owner "btsync"
  group "btsync"
end    

template "/etc/btsync/config.json" do
  source "btsync/config.json.erb"
  owner "btsync"
  group "btsync"
  mode "0600"
end
