include Iptables::Cookbook::Helpers

property :table, Symbol,
          equal_to: %i(filter mangle nat raw security),
          default: :filter,
          description: 'The table the chain should exist on'

property :chain, Symbol,
          description: 'The name of the Chain'

property :value, String,
          default: 'ACCEPT [0:0]',
          description: 'The default action and the Packets : Bytes count'

property :ip_version, Symbol,
          equal_to: %i(ipv4 ipv6),
          default: :ipv4,
          description: 'The IP version, 4 or 6'

property :source_template, String,
          default: 'iptables.erb',
          description: 'Source template to use to create the rules'

property :cookbook, String,
          default: 'iptables',
          description: 'Source cookbook to find the template in'

property :sensitive, [true, false],
          default: false,
          description: 'mark the resource as senstive'

property :config_file_full_path, String,
          default: lazy { default_iptables_rules_file(ip_version) },
          description: 'The full path to find the rules on disk'

action :create do
  # We are using the accumalator pattern here
  # This is as we are managing a single config file but using multiple
  # resouces to allow a cleaner api for the end user
  # Note, this will only ever go as a file on disk at the end of a chef run
  table_name = new_resource.table.to_s
  with_run_context :root do
    edit_resource(:template, new_resource.config_file_full_path) do |new_resource|
      source new_resource.source_template
      cookbook new_resource.cookbook
      sensitive new_resource.sensitive
      mode '644'

      variables['iptables'] ||= {}
      # We have to make sure default exists, so this is a hack to do that ...
      variables['iptables']['filter'] ||= {}
      variables['iptables']['filter']['chains'] ||= {}
      variables['iptables']['filter']['chains'] = get_default_chains_for_table(:filter) if variables['iptables']['filter']['chains'] == {}

      variables['iptables'][table_name] ||= {}
      variables['iptables'][table_name]['chains'] ||= {}
      variables['iptables'][table_name]['chains'] = get_default_chains_for_table(new_resource.table) if variables['iptables'][table_name]['chains'] == {}

      variables['iptables'][table_name]['chains'][new_resource.chain] = { value: new_resource.value } if new_resource.chain

      action :nothing
      delayed_action :create
    end
  end
end
