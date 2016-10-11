include_recipe 'iptables::default'

iptables_rule 'sshd' do
  lines '-A FWR -p tcp -m tcp --dport 22 -j ACCEPT'
end

nested 'httpd' do
  lines '-A FWR -p tcp -m tcp --dport 80 -j ACCEPT'
end

doubly_nested 'https' do
  lines '-A FWR -p tcp -m tcp --dport 443 -j ACCEPT'
end
