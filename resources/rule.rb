include Iptables::Cookbook::Helpers

property :comment, String, # --comment
          name_property: true,
          description: 'Comment for the rule'

property :table, Symbol, # -table (-t)
          equal_to: %i(filter mangle nat raw security),
          default: :filter,
          description: 'The table the chain exists on for the rule'

property :chain_target, Symbol, # after the action, e.g: -A (Append) INPUT
          description: 'The name of the Chain to target this rule on, e.g. -A INPUT',
          required: true

property :chain, Symbol,
          description: 'The name of the Chain to put this rule on',
          required: true

property :ip_version, Symbol,
          equal_to: %i(ipv4 ipv6),
          default: :ipv4,
          description: 'The IP version, 4 or 6'

property :protocol, Symbol, #--protocol (-p)
          description: 'The protocol of the rule or of the packet to check. The specified protocol can be one of :tcp, :udp, :icmp, or :all, or it can be a numeric value, representing one of these protocols or a different one. A protocol name from /etc/protocols is also allowed. A "!" argument before the protocol inverts the test. The number zero is equivalent to all. Protocol all will match with all protocols and is taken as default when this option is omitted. '

property :match, String, # --match (-m)
          description: 'extended packet matching module to use'

property :source, String, # --source (-s)
          description: "Source specification. Address can be either a network name, a hostname (please note that specifying any name to be resolved with a remote query such as DNS is a really bad idea), a network IP address (with /mask), or a plain IP address. The mask can be either a network mask or a plain number, specifying the number of 1's at the left side of the network mask. Thus, a mask of 24 is equivalent to 255.255.255.0. A \"!\" argument before the address specification inverts the sense of the address. The flag --src is an alias for this option. "

property :destination, String, # --destination (-d)
          description: "Destination specification,  Address can be either a network name, a hostname (please note that specifying any name to be resolved with a remote query such as DNS is a really bad idea), a network IP address (with /mask), or a plain IP address. The mask can be either a network mask or a plain number, specifying the number of 1's at the left side of the network mask. Thus, a mask of 24 is equivalent to 255.255.255.0. A \"!\" argument before the address specification inverts the sense of the address. The flag --src is an alias for this option."

property :jump, String, # --jump (-j)
          description: "This specifies the target of the rule; i.e., what to do if the packet matches it. The target can be a user-defined chain (other than the one this rule is in), one of the special builtin targets which decide the fate of the packet immediately, or an extension (see EXTENSIONS below). If this option is omitted in a rule (and goto is not used), then matching the rule will have no effect on the packet\'s fate, but the counters on the rule will be incremented."

property :go_to, String, # --goto (-g)
          description: 'This specifies that the processing should continue in a user specified chain. Unlike the --jump option return will not continue processing in this chain but instead in the chain that called us via --jump.'

property :in_interface, String, # --in-interface (-i)
          description: 'Name of an interface via which a packet was received (only for packets entering the INPUT, FORWARD and PREROUTING chains). When the "!" argument is used before the interface name, the sense is inverted. If the interface name ends in a "+", then any interface which begins with this name will match. If this option is omitted, any interface name will match. '

property :out_interface, String, # --out-interface (-o)
          description: 'Name of an interface via which a packet is going to be sent (for packets entering the FORWARD, OUTPUT and POSTROUTING chains). When the "!" argument is used before the interface name, the sense is inverted. If the interface name ends in a "+", then any interface which begins with this name will match. If this option is omitted, any interface name will match. '

property :fragment, String, # --fragment (-f)
          description: 'Name of an interface via which a packet is going to be sent (for packets entering the FORWARD, OUTPUT and POSTROUTING chains). When the "!" argument is used before the interface name, the sense is inverted. If the interface name ends in a "+", then any interface which begins with this name will match. If this option is omitted, any interface name will match. '

property :line_number, Integer,
          callbacks: {
            'should be a number greater than 0' => lambda { |p|
              p > 1024
            },
          },
          description: 'The location to insert the rule into for the chain'

property :extra_options, String,
          description: 'Pass in extra arguments which are not available directly, useful with modules'
### Section here is for the accumalator pattern
property :source_template, String,
          default: 'iptables.erb',
          description: 'Source template to use to create the rules'

property :cookbook, String,
          default: 'iptables',
          description: 'Source cookbook to find the template in'

property :sensitive, [true, false],
          default: false,
          description: 'mark the resource as senstive'

property :config_file, String,
          default: lazy { default_iptables_rules_file(ip_version) },
          description: 'The full path to find the rules on disk'

# Actions should be:
# append (-A, --append)
# delete (-D --delete)
# inset (-I --insert)
# While replace exists it should be a delete and re-create option in chef
# for idempotency

# This is essentially a base rule resource which other resources can call and plug in more options using the extra options field.

# This must be fully tested!

action :create do
  # We are using the accumalator pattern here
  # This is as we are managing a single config file but using multiple
  # resouces to allow a cleaner api for the end user
  # Note, this will only ever go as a file on disk at the end of a chef run
  table_name = new_resource.table.to_s

  rule = "-A #{new_resource.chain}"
  # rule << " -t #{new_resource.table.to_s}"
  rule << " -p #{new_resource.protocol}" if new_resource.protocol
  rule << " -m #{new_resource.match}" if new_resource.match
  rule << " -s #{new_resource.source}" if new_resource.source
  rule << " -d #{new_resource.destination}" if new_resource.destination
  rule << " -j #{new_resource.jump}" if new_resource.jump
  rule << " -g #{new_resource.go_to}" if new_resource.go_to
  rule << " -i #{new_resource.in_interface}" if new_resource.in_interface
  rule << " -o #{new_resource.out_interface}" if new_resource.out_interface
  rule << " -f #{new_resource.fragment}" if new_resource.fragment
  rule << " #{new_resource.extra_options}" if new_resource.extra_options
  rule << " --comment \"#{new_resource.comment}\"" if new_resource.comment

  with_run_context :root do
    edit_resource(:template, new_resource.config_file) do |new_resource|
      source new_resource.source_template
      cookbook new_resource.cookbook
      sensitive new_resource.sensitive
      mode '644'

      variables['iptables'] ||= {}
      # We have to make sure default exists, so this is a hack to do that ...
      variables['iptables']['filter'] ||= {}
      variables['iptables']['filter']['chains'] ||= {}
      variables['iptables']['filter']['chains'] = get_default_chains_for_table(:filter) if variables['iptables']['filter']['chains'] == {}

      # We have to ensure the tables are initalised so we can insert rules into them
      variables['iptables'][table_name] ||= {}
      variables['iptables'][table_name]['chains'] ||= {}
      variables['iptables'][table_name]['chains'] = get_default_chains_for_table(new_resource.table) if variables['iptables'][table_name]['chains'] == {}

      variables['iptables'][table_name]['chains'][new_resource.chain_target]['rules'] ||= []
      # If there is a line number let's insert it into the rules
      # for the chain at that point
      if new_resource.line_number
        variables['iptables'][table_name]['chains'][new_resource.chain_target]['rules'].insert(new_resource.line_number, rule)
      else
        variables['iptables'][table_name]['chains'][new_resource.chain_target]['rules'].push(rule)
      end

      action :nothing
      delayed_action :create
    end
  end
end
