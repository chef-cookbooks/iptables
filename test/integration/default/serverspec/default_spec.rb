require 'serverspec'

set :backend, :exec

# rules no longer ship by default
describe iptables do
  it { should_not have_rule('-A FWR -p tcp -m tcp --dport 22 -j ACCEPT') }
  it { should_not have_rule('-A INPUT -j FWR') }
  it { should_not have_rule('-A FWR -i lo -j ACCEPT') }
  it { should_not have_rule('-A FWR -p tcp -m tcp --tcp-flags SYN,RST,ACK SYN -j REJECT --reject-with icmp-port-unreachable') }
  it { should_not have_rule('-A FWR -p udp -j REJECT --reject-with icmp-port-unreachable') }
end

if os[:family] == 'redhat'
  describe service('iptables') do
    it { should be_enabled }
    it { should be_running }
  end
end

# the disable recipe will delete this, but the install should add it back
describe file('/etc/iptables.d') do
  it { should be_directory }
end

describe file('/usr/sbin/rebuild-iptables') do
  it { should exist }
end

if ['debian', 'ubuntu'].include?(os[:family])
  describe file('/etc/network/if-pre-up.d/iptables_load') do
    it { should exist }
  end
end

if ['centos', 'fedora'].include?(os[:family])
  describe file('/etc/sysconfig/iptables-config') do
    its(:content) { should match /IPTABLES_STATUS_VERBOSE="yes"/ }
  end

  describe file('/etc/sysconfig/ip6tables-config') do
    its(:content) { should match /IPTABLES_STATUS_VERBOSE="yes"/ }
  end
end
