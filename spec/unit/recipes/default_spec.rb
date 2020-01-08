require 'spec_helper'

describe 'iptables::default' do
  context 'Debian' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'debian', version: '9').converge(described_recipe)
    end

    it 'should install iptables' do
      expect(chef_run).to install_package('iptables')
      expect(chef_run).to install_package('iptables-persistent')
      expect(chef_run).to_not install_package('iptables-services')
    end

    %w(iptables ip6tables).each do |ipt|
      it 'should create reload resource' do
        reload_exec = chef_run.execute("reload #{ipt}")
        expect(reload_exec).to do_nothing
      end
    end

    it 'should add supporting files' do
      expect(chef_run).to create_template('/etc/network/if-pre-up.d/iptables_load')
      expect(chef_run).to create_template('/etc/network/if-pre-up.d/ip6tables_load')
    end
  end

  context 'RHEL 6' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.9').converge(described_recipe)
    end

    it 'should install iptables' do
      expect(chef_run).to_not install_package('iptables-services')
      expect(chef_run).to install_package('iptables')
      expect(chef_run).to_not install_package('iptables-persistent')
    end

    it 'should add supporting files' do
      expect(chef_run).to create_if_missing_file('/etc/sysconfig/iptables')
      expect(chef_run).to create_if_missing_file('/etc/sysconfig/ip6tables')
      expect(chef_run).to create_template('/etc/sysconfig/iptables-config')
      expect(chef_run).to create_template('/etc/sysconfig/ip6tables-config')
    end

    it 'should enable iptables-services' do
      expect(chef_run).to enable_service('iptables')
      expect(chef_run).to enable_service('ip6tables')
    end
  end

  context 'Amazon 2018' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'amazon', version: '2018').converge(described_recipe)
    end

    it 'should install iptables' do
      expect(chef_run).to_not install_package('iptables-services')
      expect(chef_run).to install_package('iptables')
      expect(chef_run).to_not install_package('iptables-persistent')
    end

    it 'should add supporting files' do
      expect(chef_run).to create_if_missing_file('/etc/sysconfig/iptables')
      expect(chef_run).to create_if_missing_file('/etc/sysconfig/ip6tables')
      expect(chef_run).to create_template('/etc/sysconfig/iptables-config')
      expect(chef_run).to create_template('/etc/sysconfig/ip6tables-config')
    end

    it 'should enable iptables-services' do
      expect(chef_run).to enable_service('iptables')
      expect(chef_run).to enable_service('ip6tables')
    end
  end

  context 'RHEL 7' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.6.1804').converge(described_recipe)
    end

    it 'should install iptables-services' do
      expect(chef_run).to install_package('iptables-services')
      expect(chef_run).to_not install_package('iptables')
      expect(chef_run).to_not install_package('iptables-persistent')
    end

    it 'should add supporting files' do
      expect(chef_run).to create_if_missing_file('/etc/sysconfig/iptables')
      expect(chef_run).to create_if_missing_file('/etc/sysconfig/ip6tables')
      expect(chef_run).to create_template('/etc/sysconfig/iptables-config')
      expect(chef_run).to create_template('/etc/sysconfig/ip6tables-config')
    end

    it 'should enable iptables-services' do
      expect(chef_run).to enable_service('iptables')
      expect(chef_run).to enable_service('ip6tables')
    end
  end

  context 'Amazon 2' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'amazon', version: '2').converge(described_recipe)
    end

    it 'should install iptables-services' do
      expect(chef_run).to install_package('iptables-services')
      expect(chef_run).to_not install_package('iptables')
      expect(chef_run).to_not install_package('iptables-persistent')
    end

    it 'should add supporting files' do
      expect(chef_run).to create_if_missing_file('/etc/sysconfig/iptables')
      expect(chef_run).to create_if_missing_file('/etc/sysconfig/ip6tables')
      expect(chef_run).to create_template('/etc/sysconfig/iptables-config')
      expect(chef_run).to create_template('/etc/sysconfig/ip6tables-config')
    end

    it 'should enable iptables-services' do
      expect(chef_run).to enable_service('iptables')
      expect(chef_run).to enable_service('ip6tables')
    end
  end

  context 'Fedora' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'fedora', version: '29').converge(described_recipe)
    end

    it 'should install iptables-services' do
      expect(chef_run).to install_package('iptables-services')
      expect(chef_run).to_not install_package('iptables')
      expect(chef_run).to_not install_package('iptables-persistent')
    end

    it 'should add supporting files' do
      expect(chef_run).to create_if_missing_file('/etc/sysconfig/iptables')
      expect(chef_run).to create_if_missing_file('/etc/sysconfig/ip6tables')
      expect(chef_run).to create_template('/etc/sysconfig/iptables-config')
      expect(chef_run).to create_template('/etc/sysconfig/ip6tables-config')
    end

    it 'should enable iptables-services' do
      expect(chef_run).to enable_service('iptables')
      expect(chef_run).to enable_service('ip6tables')
    end
  end
end
