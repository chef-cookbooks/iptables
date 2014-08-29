require 'serverspec'

include Serverspec::Helper::Exec
include SpecInfra::Helper::DetectOS

describe iptables do
  it { should have_rule('-A FWR -p tcp -m tcp --dport 22 -j ACCEPT') }
end
