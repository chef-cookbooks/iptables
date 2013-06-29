package "iptables"

rules_to_apply = []
myRoles = node['roles']
source_addresses = []

myRoles.each do |myRole|
  #dynamic rules
  node['iptables']['role'].each do |role_rule|
    if role_rule[0] == myRole
      begin
        search(:node, "roles:#{role_rule[3]}").each do |anode|
          begin
            addresses_for_iptables_rule = anode["network"]["interfaces"][node["network_interfaces"][role_rule[2]]]["addresses"].select { |address, data| data["family"] == "inet" }.keys.first
            source_addresses = [source_addresses, addresses_for_iptables_rule].flatten.compact

          rescue => e
            log "node's expected attributes are incorrect: #{role_rule} : #{anode} : #{e}" do
              level :warn
            end
            next
          end
        end
      rescue => e
        log "chef search failed: #{role_rule} : #{e}" do
          level :warn
        end
        next
      end
      if source_addresses == nil
        log "no nodes match ruleset either because of an error or because there aren't any: #{role_rule}"
        next
      end
      if not source_addresses.empty?
        role_rule[5] = [role_rule[5], source_addresses].flatten.compact
        rules_to_apply.push(role_rule)
      end
    end
    source_addresses = nil
  end
  #static rules
  node['iptables']['static'].each do |static_rule|
    if static_rule[0] == myRole
      rules_to_apply.push(static_rule)
    end
  end
end

execute "rebuild-iptables" do
  command "/usr/sbin/rebuild-iptables || /sbin/iptables-restore < /etc/iptables/fallback "
  action :nothing
end

directory "/etc/iptables.d" do
  action :create
end

cookbook_file "/usr/sbin/rebuild-iptables" do
  source "rebuild-iptables"
  mode 0555
end

cookbook_file "/etc/iptables/fallback" do
  source "fallback.iptables"
  mode 0755
end

case node[:platform]
  when "ubuntu", "debian"
    iptables_save_file = "/etc/iptables/general"

    template "/etc/network/if-pre-up.d/iptables_load" do
      source "iptables_load.erb"
      mode 0755
      variables :iptables_save_file => iptables_save_file
    end
end


iptables_rule "iptables2" do
  variables(
      :rules => rules_to_apply
  )
  only_if { node['iptables']['apply_new_rules'] }
end
