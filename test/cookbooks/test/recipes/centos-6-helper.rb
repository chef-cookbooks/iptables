# CentOS 6 on Bento requires the iptables modules loading

%w(ip_tables iptable_filter iptable_mangle iptable_nat).each do |mod|
  next if Mixlib::ShellOut.new("lsmod | grep #{mod}").run_command.exitstatus.eql?(0)

  kernel_module mod do
    action :load
  end
end
