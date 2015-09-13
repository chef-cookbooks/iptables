require 'serverspec'

include Serverspec::Helper::Exec

describe command('iptables-save') do
  it { should return_stdout /FWR/ }
end
