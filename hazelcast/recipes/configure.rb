template "hazelcast.cfg-linux" do
  path "/opt/hazelcast/hazelcast-3.5.3/bin/hazelcast.xml"
  source "hazelcast.cfg-linux.erb"
  owner "hazelcast"
  group "hazelcast"
  mode 0644
end

template "server.cfg-linux" do
  path "/opt/hazelcast/hazelcast-3.5.3/bin/server.sh"
  source "server.cfg-linux.erb"
  owner "hazelcast"
  group "hazelcast"
  mode 0744
end