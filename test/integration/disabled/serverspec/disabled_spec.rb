require 'serverspec'

set :backend, :exec

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
