describe file('/tmp/custom-template') do
  its('content') { should eq "This was generated using a custom template.\n" }
  its('mode') { should eq 0o600 }
end
