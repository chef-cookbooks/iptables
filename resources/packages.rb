unified_mode true

include Iptables::Cookbook::Helpers

property :packages, Array,
          default: lazy { package_names },
          description: 'The packages to install for iptables'

%i(install purge reconfig remove upgrade).each do |service_action|
  action service_action do
    package 'iptables' do
      package_name new_resource.packages
      action service_action
    end
  end
end
