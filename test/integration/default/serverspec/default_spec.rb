require 'serverspec'

set :backend, :exec

if os[:family] == 'redhat'
  describe command('/etc/init.d/iptables status') do
    its(:stdout) { should match /Table: filter/ }
  end
end

# the disable recipe will delete this, but the install should add it back
describe file('/etc/iptables.d') do
  it { should be_directory }
end

describe file('/usr/sbin/rebuild-iptables') do
  it { should exist }
end

if %w(debian ubuntu).include?(os[:family])
  describe file('/etc/network/if-pre-up.d/iptables_load') do
    it { should exist }
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
