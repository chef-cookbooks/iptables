case os.family
when 'redhat', 'fedora', 'amazon'
  describe service('iptables') do
    it { should be_installed }
    it { should_not be_enabled }
    it { should_not be_running }
  end

  %w(iptables ip6tables).each do |file|
    describe file("/etc/sysconfig/#{file}") do
      it { should exist }
      it { should be_file }
      its(:content) { should match(/^# iptables rules files cleared by chef via iptables::disabled$/) }
    end
  end
when 'debian', 'ubuntu'
  describe service('netfilter-persistent') do
    it { should be_installed }
    it { should_not be_enabled }
    it { should_not be_running }
  end

  %w(v4 v6).each do |variant|
    describe file("/etc/iptables/rules.#{variant}") do
      it { should exist }
      it { should be_file }
      its(:content) { should match(/^# iptables rules files cleared by chef via iptables::disabled$/) }
    end
  end
end
