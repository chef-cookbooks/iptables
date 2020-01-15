# This will create all tables possible on the server
# and validate that they are all there with the correct default chains

iptables_packages 'install iptables'
iptables_service 'configure iptables services'

iptables_chain 'filter' do
  table :filter
end

iptables_chain 'mangle' do
  table :mangle
end

iptables_chain 'nat' do
  table :nat
end

iptables_chain 'raw' do
  table :raw
end

iptables_chain 'security' do
  table :security
end
