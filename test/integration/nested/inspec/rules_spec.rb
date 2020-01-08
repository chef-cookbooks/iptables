if os[:family] == 'redhat' && os[:release].start_with?('6')
  describe iptables do
    it { should have_rule('-A FWR -p tcp -m tcp --dport 22 -j ACCEPT') }
    it { should have_rule('-A FWR -p tcp -m tcp --dport 80 -m comment --comment "httpd" -j ACCEPT') }
    it { should have_rule('-A FWR -p tcp -m tcp --dport 443 -m comment --comment "https" -j ACCEPT') }
  end
else
  describe iptables do
    it { should have_rule('-A FWR -p tcp -m tcp --dport 22 -j ACCEPT') }
    it { should have_rule('-A FWR -p tcp -m tcp --dport 80 -m comment --comment httpd -j ACCEPT') }
    it { should have_rule('-A FWR -p tcp -m tcp --dport 443 -m comment --comment https -j ACCEPT') }
  end
end
