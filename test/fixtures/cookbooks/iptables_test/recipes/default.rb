apt_update ''

include_recipe 'iptables::default'

iptables_chain 'fwr' do
  chain 'FWR'
end

iptables_rule 'sshd' do
  chain 'FWR'
  match '-p tcp -m tcp --dport 22'
  target 'ACCEPT'
  comment 'Allow SSH'
  sensitive true
end

iptables_rule 'icmp' do
  line '-A INPUT -p icmp -m comment --comment accept_icmp -j ACCEPT'
end

iptables_rule 'fwr_jump' do
  chain 'INPUT'
  target 'FWR'
  comment 'Jump FWR'
end

iptables_rule 'logging_jump' do
  chain 'INPUT'
  target 'LOGGING'
  comment 'Jump LOGGING'
end

iptables_rule 'logging' do
  chain 'LOGGING'
  line '-A LOGGING -m limit --limit 1/sec -j LOG --log-prefix "Testing rule"'
  comment false
end

iptables_chain6 'fwr' do
  chain 'FWR'
end

iptables_rule6 'sshd' do
  chain 'FWR -'
  match '-p tcp -m tcp --dport 22'
  target 'ACCEPT'
  comment 'Allow ICMPv6'
  sensitive true
end

iptables_rule6 'dhcpv6' do
  line '-A INPUT -d fe80::/10 -p udp -m udp --dport 546 -m state --state NEW -j ACCEPT'
end

iptables_chain 'logging' do
  chain 'LOGGING'
end
