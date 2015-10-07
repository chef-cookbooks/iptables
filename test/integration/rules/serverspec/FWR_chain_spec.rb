require 'serverspec'

set :backend, :exec

describe command('iptables-save') do
  its(:stdout) { should match /FWR/ }
end
