unified_mode true

include Iptables::Cookbook::Helpers

property :config_file, String,
          default: lazy { default_iptables_rules_file(ip_version) },
          description: 'The full path to find the rules on disk'

property :owner, String,
          default: 'root',
          description: 'Permissions on the saved output file'

property :group, String,
          default: 'root',
          description: 'Permissions on the saved output file'

property :mode, String,
          default: '0600',
          description: 'Permissions on the saved output file'

property :cookbook, String,
          default: 'iptables',
          description: 'Source cookbook to find the template in'

property :template, String,
          default: 'iptables.erb',
          description: 'Source template to use to create the rules'

property :sensitive, [true, false],
          default: true,
          description: 'Mark the resource as senstive'

property :ip_version, [Symbol, String],
          coerce: proc { |p| p.to_sym },
          equal_to: %i(ipv4 ipv6),
          default: :ipv4,
          description: 'The IP version, 4 or 6'

property :table, [Symbol, String],
          coerce: proc { |p| p.to_sym },
          equal_to: Iptables::Cookbook::Helpers::IPTABLES_TABLE_NAMES,
          required: true,
          description: 'The table the chain should exist on'

property :chain, [Symbol, String],
          coerce: proc { |p| p.to_sym },
          description: 'The name of the Chain'

property :value, String,
          default: 'ACCEPT [0:0]',
          description: 'The default action and the Packets : Bytes count'

action_class do
  include Iptables::Cookbook::ResourceHelpers
  include Iptables::Cookbook::TemplateHelpers
end

action :create do
  rulefile_resource_init
  rulefile_resource.variables[:iptables][new_resource.table][:chains][new_resource.chain] = new_resource.value unless nil_or_empty?(new_resource.chain)
end

action :delete do
  rulefile_resource_init
  rulefile_resource.variables[:iptables][new_resource.table][:chains].delete(new_resource.chain)
end
