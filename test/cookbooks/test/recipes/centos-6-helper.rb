# CentOS 6 on Bento requires the iptables modules loading

%w(ip_tables iptable_filter iptable_mangle iptable_nat).each do |mod|
  next if node['kernel']['modules'].keys.include?(mod)

  begin
    kernel_module mod do
      action :load
    end
  rescue Mixlib::ShellOut::ShellCommandFailed
    Chef::Log.warn("Failed to load kernel module #{mod}. On containers/cloud this is expected.")
  end
end
