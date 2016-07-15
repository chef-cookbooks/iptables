include_recipe 'iptables::default'

iptables_rule 'sshd' do
  lines '-A FWR -p tcp -m tcp --dport 22 -j ACCEPT'
end
