include_recipe 'iptables::default'

iptables_rule 'sshd' do
  content "-A FWR -p tcp -m tcp --dport 22 -j ACCEPT"
end
