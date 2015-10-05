require 'serverspec'

set :backend, :exec

describe iptables do
  it { should_not have_rule('-A FWR -p tcp -m tcp --dport 22 -j ACCEPT') }
  it { should_not have_rule('-A INPUT -j FWR') }
  it { should_not have_rule('-A FWR -i lo -j ACCEPT') }
  it { should_not have_rule('-A FWR -p tcp -m tcp --tcp-flags SYN,RST,ACK SYN -j REJECT --reject-with icmp-port-unreachable') }
  it { should_not have_rule('-A FWR -p udp -j REJECT --reject-with icmp-port-unreachable') }
end
