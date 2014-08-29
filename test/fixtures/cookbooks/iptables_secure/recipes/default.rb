iptables_rule "sshd"

bash "Dirty hack to open a port" do
  user "root"
  cwd "/tmp"
  code "nohup python -mSimpleHTTPServer &"
end
