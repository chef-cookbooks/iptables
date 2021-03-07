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
          description: 'Source template to use to create the rule file'

property :sensitive, [true, false],
          default: true,
          description: 'Mark the resource as senstive'

property :ip_version, [Symbol, String],
          coerce: proc { |p| p.to_sym },
          equal_to: %i(ipv4 ipv6),
          default: :ipv4,
          description: 'The IP version, 4 or 6'

property :service_name, String,
          default: lazy { default_service_name(ip_version) },
          description: 'Name of the iptables services'

property :sysconfig_file, String,
          default: lazy { default_sysconfig_path(ip_version) },
          description: 'The full path to find the sysconfig file on disk'

property :sysconfig_template, String,
          default: 'iptables-config.erb',
          description: 'Source template to use to create the rule file'

property :sysconfig, Hash,
          default: lazy { default_sysconfig(ip_version) },
          description: 'The sysconfig settings'

action_class do
  include Iptables::Cookbook::ResourceHelpers

  SERVICE_PRE_ACTIONS_REQUIRED ||= %i(start restart reload).freeze

  def do_service_action(resource_action)
    edit_resource(:service, new_resource.service_name).action(resource_action)
  end

  def do_redhat_pre_actions
    edit_resource(:template, new_resource.sysconfig_file) do
      owner new_resource.owner
      group new_resource.group
      mode new_resource.mode

      source new_resource.sysconfig_template
      cookbook new_resource.cookbook
      sensitive new_resource.sensitive

      variables['config'] = new_resource.sysconfig

      helpers(Iptables::Cookbook::TemplateHelpers)

      action :create
    end
  end
end

%i(start stop restart reload enable disable).each do |service_action|
  action service_action do
    rulefile_resource_init
    do_redhat_pre_actions if platform_family?('rhel', 'fedora', 'amazon') && SERVICE_PRE_ACTIONS_REQUIRED.include?(action)
    do_service_action(action)
  end
end
