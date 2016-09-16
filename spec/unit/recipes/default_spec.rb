require 'spec_helper'

describe 'iptables::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'should execute rebuild-iptables' do
    expect(chef_run).to_not run_execute('rebuild-iptables')
  end

  it 'should create /etc/iptables.d' do
    expect(chef_run).to create_directory('/etc/iptables.d')
  end

  it 'should create /usr/sbin/rebuild-iptables from a template' do
    expect(chef_run).to create_template('/usr/sbin/rebuild-iptables').with(
      mode: '0755'
    )
  end

  context 'debian' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
    end

    it 'should create /etc/network/if-pre-up.d/iptables_load from a template' do
      expect(chef_run).to create_template('/etc/network/if-pre-up.d/iptables_load')
    end

    it 'should install iptables' do
      expect(chef_run).to install_package('iptables')
      expect(chef_run).to_not install_package('iptables-services')
    end
  end

  context 'rhel 7' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'redhat', version: '7.0').converge(described_recipe)
    end

    it 'should not create /etc/network/if-pre-up.d/iptables_load from a template' do
      expect(chef_run).to_not create_template('/etc/network/if-pre-up.d/iptables_load')
    end

    it 'should install iptables-services' do
      expect(chef_run).to install_package('iptables-services')
      expect(chef_run).to_not install_package('iptables')
    end

    it 'should enable iptables-services' do
      expect(chef_run).to enable_service('iptables')
    end
  end
end
