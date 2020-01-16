# This will create a rule using the line property

iptables_packages 'install iptables'
iptables_service 'configure iptables services'

iptables_chain 'filter' do
  table :filter
end

iptables_rule 'insert line directly' do
  table :filter
  line '-A INPUT -i eth0 -j ACCEPT'
end
