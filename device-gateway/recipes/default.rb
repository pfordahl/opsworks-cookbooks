cookbook_file "/tmp/env-configure.sh" do
  source "env-configure.sh"
  mode 0755
end

execute "env-configure.sh" do
  user "root"
  cwd "/tmp"
  command "./env-configure.sh"
end