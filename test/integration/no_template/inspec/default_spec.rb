case os.family
when 'redhat', 'fedora'
  if os[:release].start_with?('6')
    describe command('/etc/init.d/iptables status') do
      its(:stdout) { should match /Table: filter/ }
    end
  end

  %w(iptables ip6tables).each do |variant|
    describe file("/etc/sysconfig/#{variant}-config") do
      its(:content) { should match /IPTABLES_STATUS_VERBOSE="yes"/ }
    end
  end
when 'debian', 'ubuntu'
  %w(v4 v6).each do |variant|
    describe file("/etc/iptables/rules.#{variant}") do
      it { should exist }
    end
  end
end
