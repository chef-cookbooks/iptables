describe iptables do
  it { should have_rule('-A FWR -p tcp -m tcp --dport 22 -j ACCEPT') }
  it { should have_rule('-A FWR -p tcp -m tcp --dport 80 -j ACCEPT') }
  it { should have_rule('-A FWR -p tcp -m tcp --dport 443 -j ACCEPT') }
end
