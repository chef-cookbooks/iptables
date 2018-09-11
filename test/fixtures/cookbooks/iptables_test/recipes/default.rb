apt_update

include_recipe 'iptables::default'

iptables_rule 'sshd'

iptables_rule6 'sshd'

iptables_rule6 'dhcpv6' do
  lines '-A INPUT -d fe80::/10 -p udp -m udp --dport 546 -m state --state NEW -j ACCEPT'
end
