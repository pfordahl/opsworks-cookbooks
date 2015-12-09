cookbook_file "/tmp/hazelcast-configure.sh" do
  source "hazelcast-configure.sh"
  mode 0755
end

execute "hazelcast-configure.sh" do
  user "root"
  cwd "/tmp"
  command "./hazelcast-configure.sh"
end

cookbook_file '/opt/hazelcast/hazelcast-3.5.3/lib/logback-core-1.1.3.jar' do
  source 'logback-core-1.1.3.jar'
  owner 'root'
  group 'root'
  mode 0644
end
cookbook_file '/opt/hazelcast/hazelcast-3.5.3/lib/logback.xml' do
  source 'logback-core-1.1.3.jar'
  owner 'root'
  group 'root'
  mode 0644
end
cookbook_file '/opt/hazelcast/hazelcast-3.5.3/lib/slf4j-api-1.7.13.jar' do
  source 'logback-core-1.1.3.jar'
  owner 'root'
  group 'root'
  mode 0644
end
cookbook_file '/opt/hazelcast/hazelcast-3.5.3/lib/slf4j-ext-1.7.13.jar' do
  source 'logback-core-1.1.3.jar'
  owner 'root'
  group 'root'
  mode 0644
end
cookbook_file '/opt/hazelcast/hazelcast-3.5.3/lib/slf4j-simple-1.7.13.jar' do
  source 'logback-core-1.1.3.jar'
  owner 'root'
  group 'root'
  mode 0644
end