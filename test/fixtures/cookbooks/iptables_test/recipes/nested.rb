apt_update

include_recipe 'iptables::default'

iptables_chain 'fwr_chain' do
  chain 'FWR -'
end

iptables_rule 'sshd' do
  line '-A FWR -p tcp -m tcp --dport 22 -j ACCEPT'
  comment false
end

iptables_chain6 'fwr_chain' do
  chain 'FWR'
end

iptables_rule6 'sshd' do
  line '-A FWR -p tcp -m tcp --dport 22 -j ACCEPT'
  comment false
end

nested 'httpd' do
  lines '-A FWR -p tcp -m tcp --dport 80 -j ACCEPT'
end

doubly_nested 'https' do
  lines '-A FWR -p tcp -m tcp --dport 443 -j ACCEPT'
end
