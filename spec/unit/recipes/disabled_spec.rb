require 'spec_helper'

describe 'iptables::disabled' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'deletes /etc/iptables.d directory' do
    expect(chef_run).to delete_directory('/etc/iptables.d')
  end

  context 'debian' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
    end

    it 'installs package iptables' do
      expect(chef_run).to install_package('iptables')
      expect(chef_run).to_not install_package('iptables-services')
    end
  end

  context 'rhel 7' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'redhat', version: '7.0').converge(described_recipe)
    end

    it 'should install iptables-services' do
      expect(chef_run).to install_package('iptables-services')
      expect(chef_run).to_not install_package('iptables')
    end

    it 'disables and stops iptables service' do
      expect(chef_run).to disable_service('iptables')
      expect(chef_run).to stop_service('iptables')
    end
  end
end
