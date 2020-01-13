case os.family
when 'redhat', 'fedora'
  %w(iptables ip6tables).each do |variant|
    describe file("/etc/sysconfig/#{variant}-config") do
      its(:content) { should match(/IPTABLES_STATUS_VERBOSE="yes"/) }
    end
  end
when 'debian', 'ubuntu'
  %w(v4 v6).each do |variant|
    describe file("/etc/iptables/rules.#{variant}") do
      it { should exist }
    end
  end
end
