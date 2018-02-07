if os[:family] == 'redhat'
  describe service('iptables') do
    it { should be_installed }
    it { should_not be_enabled }
    it { should_not be_running }
  end
end

# the disable recipe will delete this, but the install should add it back
describe file('/etc/iptables.d') do
  it { should_not be_directory }
end

# some RHEL/CentOS versions use these files to persist rules. disable recipe
# "clears" these files out.
%w(/etc/sysconfig/iptables /etc/sysconfig/iptables.fallback).each do |file|
  describe file(file) do
    it { should exist }
    it { should be_file }
    its(:content) { should match(/^# iptables rules files cleared by chef via iptables::disabled$/) }
  end
end
