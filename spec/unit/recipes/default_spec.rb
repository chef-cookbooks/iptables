require 'spec_helper'

describe 'iptables::default' do
  cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

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
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
    end

    it 'should install iptables' do
      expect(chef_run).to install_package('iptables')
      expect(chef_run).to install_package('iptables-persistent')
      expect(chef_run).to_not install_package('iptables-services')
    end
  end

  context 'rhel 6' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6').converge(described_recipe)
    end

    it 'should install iptables' do
      expect(chef_run).to_not install_package('iptables-services')
      expect(chef_run).to install_package('iptables')
      expect(chef_run).to_not install_package('iptables-persistent')
    end

    it 'should enable iptables-services' do
      expect(chef_run).to enable_service('iptables')
    end
  end

  context 'amazon 2018' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'amazon', version: '2018').converge(described_recipe)
    end

    it 'should install iptables' do
      expect(chef_run).to_not install_package('iptables-services')
      expect(chef_run).to install_package('iptables')
      expect(chef_run).to_not install_package('iptables-persistent')
    end

    it 'should enable iptables-services' do
      expect(chef_run).to enable_service('iptables')
    end
  end

  context 'rhel 7' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7').converge(described_recipe)
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

  context 'amazon 2' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'amazon', version: '2').converge(described_recipe)
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

  context 'fedora' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'fedora').converge(described_recipe)
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
