cookbook_file "/tmp/apache-install.sh" do
  source "apache-install.sh"
  mode 0755
end

execute "apache-install.sh" do
  user "root"
  cwd "/tmp"
  command "./apache-install.sh"
end