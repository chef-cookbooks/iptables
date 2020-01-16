iptables_packages 'install iptables'
iptables_service 'configure iptables services'

iptables_service 'remove-services' do
  action :disable
end

iptables_packages 'remove-packages' do
  action :remove
end
