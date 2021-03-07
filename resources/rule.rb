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
          default: :filter,
          description: 'The table the chain exists on for the rule'

property :chain, [Symbol, String],
          coerce: proc { |p| p.to_sym },
          description: 'The name of the Chain to put this rule on'

property :protocol, [Symbol, String, Integer],
          description: 'The protocol of the rule or of the packet to check. The specified protocol can be one of :tcp, :udp, :icmp, or :all, or it can be a numeric value, representing one of these protocols or a different one. A protocol name from /etc/protocols is also allowed. A "!" argument before the protocol inverts the test. The number zero is equivalent to all. Protocol all will match with all protocols and is taken as default when this option is omitted. '

property :match, String,
          description: 'Extended packet matching module to use'

property :source, String,
          description: "Source specification. Address can be either a network name, a hostname (please note that specifying any name to be resolved with a remote query such as DNS is a really bad idea), a network IP address (with /mask), or a plain IP address. The mask can be either a network mask or a plain number, specifying the number of 1's at the left side of the network mask. Thus, a mask of 24 is equivalent to 255.255.255.0. A \"!\" argument before the address specification inverts the sense of the address. The flag --src is an alias for this option. "

property :destination, String,
          description: "Destination specification,  Address can be either a network name, a hostname (please note that specifying any name to be resolved with a remote query such as DNS is a really bad idea), a network IP address (with /mask), or a plain IP address. The mask can be either a network mask or a plain number, specifying the number of 1's at the left side of the network mask. Thus, a mask of 24 is equivalent to 255.255.255.0. A \"!\" argument before the address specification inverts the sense of the address. The flag --src is an alias for this option."

property :jump, String,
          description: "This specifies the target of the rule; i.e., what to do if the packet matches it. The target can be a user-defined chain (other than the one this rule is in), one of the special builtin targets which decide the fate of the packet immediately, or an extension (see EXTENSIONS below). If this option is omitted in a rule (and goto is not used), then matching the rule will have no effect on the packet\'s fate, but the counters on the rule will be incremented."

property :go_to, String,
          description: 'This specifies that the processing should continue in a user specified chain. Unlike the --jump option return will not continue processing in this chain but instead in the chain that called us via --jump.'

property :in_interface, String,
          description: 'Name of an interface via which a packet was received (only for packets entering the INPUT, FORWARD and PREROUTING chains). When the "!" argument is used before the interface name, the sense is inverted. If the interface name ends in a "+", then any interface which begins with this name will match. If this option is omitted, any interface name will match. '

property :out_interface, String,
          description: 'Name of an interface via which a packet is going to be sent (for packets entering the FORWARD, OUTPUT and POSTROUTING chains). When the "!" argument is used before the interface name, the sense is inverted. If the interface name ends in a "+", then any interface which begins with this name will match. If this option is omitted, any interface name will match. '

property :fragment, String,
          description: 'Name of an interface via which a packet is going to be sent (for packets entering the FORWARD, OUTPUT and POSTROUTING chains). When the "!" argument is used before the interface name, the sense is inverted. If the interface name ends in a "+", then any interface which begins with this name will match. If this option is omitted, any interface name will match. '

property :line_number, Integer,
          callbacks: {
            'should be a number greater than 0' => lambda { |p|
              p > 0
            },
          },
          description: 'The location to insert the rule into for the chain'

property :extra_options, String,
          description: 'Pass in extra arguments which are not available directly, useful with modules'

property :comment, String,
          coerce: proc { |p| "\"#{p}\"" },
          description: 'An optional comment to add to the rule'

property :line, String,
          description: 'Specify the entire line yourself, overriding all other options'

action_class do
  include Iptables::Cookbook::ResourceHelpers
end

action :create do
  rulefile_resource_init

  if new_resource.line_number
    rulefile_resource.variables[:iptables][new_resource.table][:rules].insert((new_resource.line_number - 1), rule_builder)
  else
    rulefile_resource.variables[:iptables][new_resource.table][:rules].push(rule_builder)
  end
end

action :delete do
  rulefile_resource_init
  rulefile_resource.variables[:iptables][new_resource.table][:rules].delete(rule)
end
