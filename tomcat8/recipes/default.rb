cookbook_file "/tmp/tomcat-install.sh" do
  source "tomcat-install.sh"
  mode 0755
end

execute "tomcat-install.sh" do
  user "root"
  cwd "/tmp"
  command "./tomcat-install"
end