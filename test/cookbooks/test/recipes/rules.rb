# This will create a multitude of rules under multiple
# tables and validate that they all created correctly

iptables_packages 'install iptables'
iptables_service 'configure iptables services'

iptables_chain 'mangle' do
  table :mangle
  chain :DIVERT
  value '- [0:0]'
end

iptables_rule 'Divert tcp prerouting' do
  table :mangle
  chain :PREROUTING
  protocol :tcp
  match 'socket'
  ip_version :ipv4
  jump 'DIVERT'
end

iptables_rule 'Mark Diverted rules' do
  table :mangle
  chain :DIVERT
  ip_version :ipv4
  jump 'MARK'
  extra_options '--set-xmark 0x1/0xffffffff'
end

iptables_rule 'accept divert trafic' do
  table :mangle
  chain :DIVERT
  ip_version :ipv4
  jump 'ACCEPT'
end
