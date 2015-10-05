require 'serverspec'

set :backend, :exec

describe command('iptables-save') do
  it { should return_stdout /FWR/ }
end
