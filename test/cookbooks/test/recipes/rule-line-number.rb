# This will test that inserting a rule at a given number
# will output the rule correctly

iptables_packages 'install iptables'
iptables_service 'configure iptables services'

iptables_chain 'filter' do
  table :filter
end

iptables_rule 'Allow from loopback interface' do
  table :filter
  chain :INPUT
  ip_version :ipv4
  jump 'ACCEPT'
  in_interface 'lo'
end

# This should be the first rule now
iptables_rule 'Allow from loopback interface' do
  table :filter
  chain :INPUT
  ip_version :ipv4
  jump 'ACCEPT'
  in_interface 'eth0'
  line_number 1
end
