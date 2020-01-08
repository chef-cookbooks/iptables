%w(iptables ip6tables).each do |variant|
  if %w(debian ubuntu).include?(os[:family])
    describe file("/etc/network/if-pre-up.d/#{variant}_load") do
      it { should exist }
    end
  elsif %w(redhat fedora).include?(os[:family])
    describe file("/etc/sysconfig/#{variant}-config") do
      its(:content) { should match(/IPTABLES_STATUS_VERBOSE="yes"/) }
    end
  end
end
