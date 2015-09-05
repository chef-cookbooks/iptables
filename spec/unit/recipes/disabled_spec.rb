require 'spec_helper'

describe 'iptables::disabled' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'installs package iptables' do
    expect(chef_run).to install_package('iptables')
  end

  it 'disables and stops iptables service' do
    expect(chef_run).to disable_service('iptables')
    expect(chef_run).to stop_service('iptables')
  end
end
