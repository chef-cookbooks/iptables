require 'serverspec'

set :backend, :exec

describe iptables do
  it { should have_rule('-A FWR -p tcp -m tcp --dport 22 -j ACCEPT') }
end
