apt_update

include_recipe 'iptables::default'

iptables_chain 'fwr' do
  chain 'FWR'
  value '- [0:0]'
end

iptables_rule 'sshd' do
  chain 'FWR'
  match 'tcp'
  extra_options '-p tcp --dport 22'
  target 'ACCEPT'
  sensitive false
end

iptables_rule 'icmp' do
  chain :INPUT
  line '-A INPUT -p icmp -m comment --comment accept_icmp -j ACCEPT'
end

iptables_rule 'fwr_jump' do
  chain :INPUT
  target 'FWR'
end

iptables_chain 'logging' do
  chain 'LOGGING'
  value '- [0:0]'
end

iptables_rule 'logging_jump' do
  chain :INPUT
  target 'LOGGING'
end

iptables_rule 'logging' do
  chain 'LOGGING'
  line '-A LOGGING -m limit --limit 1/sec -j LOG --log-prefix "Testing rule"'
end

iptables_chain6 'fwr' do
  chain 'FWR'
  value '- [0:0]'
end

iptables_rule6 'sshd' do
  chain 'FWR'
  match 'tcp'
  extra_options '-p tcp --dport 22'
  target 'ACCEPT'
  sensitive false
end

iptables_rule6 'dhcpv6' do
  chain :INPUT
  line '-A INPUT -d fe80::/10 -p udp -m udp --dport 546 -m state --state NEW -j ACCEPT'
end
