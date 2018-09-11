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

    it 'should install iptables' do
      expect(chef_run).to install_package('iptables')
      expect(chef_run).to install_package('iptables-persistent')
      expect(chef_run).to_not install_package('iptables-services')
    end
  end

  context 'rhel 6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.9').converge(described_recipe)
    end

    it 'should install iptables' do
      expect(chef_run).to install_package('iptables')
      expect(chef_run).to_not install_package('iptables-services')
      expect(chef_run).to_not install_package('iptables-persistent')
    end

    it 'should enable iptables' do
      expect(chef_run).to enable_service('iptables')
    end
  end

  context 'rhel 7' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.4.1708').converge(described_recipe)
    end

    it 'should install iptables-services' do
      expect(chef_run).to install_package('iptables-services')
      expect(chef_run).to_not install_package('iptables')
      expect(chef_run).to_not install_package('iptables-persistent')
    end

    it 'should enable iptables-services' do
      expect(chef_run).to enable_service('iptables')
    end
  end
end
