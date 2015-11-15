if defined?(ChefSpec)
  def enable_iptables_rule(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:iptables_rule, :enable, resource_name)
  end

  def disable_iptables_rule(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:iptables_rule, :disable, resource_name)
  end
end
