if os[:family] == 'redhat' && os[:release].start_with?('6')
  describe command('/etc/init.d/iptables status') do
    its(:stdout) { should match /Table: filter/ }
  end
end

%w(iptables ip6tables).each do |variant|
  # the disable recipe will delete this, but the install should add it back
  describe file("/etc/#{variant}.d") do
    it { should be_directory }
  end

  describe file("/usr/sbin/rebuild-#{variant}") do
    it { should exist }
  end

  if %w(debian ubuntu).include?(os[:family])
    describe file("/etc/network/if-pre-up.d/#{variant}_load") do
      it { should exist }
    end
  end
end

if %w(redhat fedora).include?(os[:family])
  describe file('/etc/sysconfig/iptables-config') do
    its(:content) { should match /IPTABLES_STATUS_VERBOSE="yes"/ }
  end

  describe file('/etc/sysconfig/ip6tables-config') do
    its(:content) { should match /IPTABLES_STATUS_VERBOSE="yes"/ }
  end
end
