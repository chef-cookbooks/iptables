include Iptables::Cookbook::Helpers

property :packages, Array,
  default: lazy { get_package_names },
  required: true
  description: 'The packages to install for iptables'

action :installl do
  
  package 'iptables' do
    package_name new_resources.packages
    action :install
  end
end

action :remove do
  package 'iptables' do
    package_name new_resources.packages
    action :remove
  end
end
