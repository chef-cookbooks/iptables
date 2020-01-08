apt_update

include_recipe 'iptables::default'

iptables_chain 'fwr' do
  chain 'FWR'
end

iptables_rule 'sshd' do
  chain 'FWR'
  line '-A FWR -p tcp -m tcp --dport 22 -j ACCEPT'
end
