# CentOS 6 on Bento needs the ip_conntrack module loading

%w(ip_conntrack ip_tables iptable_filter iptable_mangle iptable_nat).each { |mod| kernel_module mod }
