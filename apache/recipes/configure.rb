template "apache.cfg-linux" do
  path "/etc/httpd/conf/httpd.conf"
  source "apache.cfg-linux.erb"
  owner "apache"
  group "apache"
  mode 0644
end

cookbook_file "/tmp/apache-configure.sh" do
  source "apache-configure.sh"
  mode 0755
end

execute "apache-configure.sh" do
  user "root"
  cwd "/tmp"
  command "./apache-configure.sh"
end