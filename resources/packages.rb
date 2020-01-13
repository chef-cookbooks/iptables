include Iptables::Cookbook::Helpers

property :packages, Array,
  default: lazy { package_names },
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
