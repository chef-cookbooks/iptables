require 'spec_helper'

describe 'iptables::disabled' do
  context 'Debian' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'debian', version: '9').converge(described_recipe)
    end

    it 'installs package iptables' do
      expect(chef_run).to install_package('iptables')
      expect(chef_run).to install_package('iptables-persistent')
      expect(chef_run).to_not install_package('iptables-services')
    end

    %w(iptables ip6tables).each do |ipt|
      it 'should create flush resource' do
        reload_exec = chef_run.execute("flush #{ipt}")
        expect(reload_exec).to do_nothing
      end
    end
  end

  context 'RHEL 7' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '7.6.1804').converge(described_recipe)
    end

    it 'should install iptables-services' do
      expect(chef_run).to install_package('iptables-services')
      expect(chef_run).to_not install_package('iptables')
      expect(chef_run).to_not install_package('iptables-persistent')
    end

    %w(iptables ip6tables).each do |ipt|
      it 'should create flush resource' do
        reload_exec = chef_run.execute("flush #{ipt}")
        expect(reload_exec).to do_nothing
      end

      it 'should create fallback files' do
        expect(chef_run).to create_file("/etc/sysconfig/#{ipt}")
        expect(chef_run).to create_file("/etc/sysconfig/#{ipt}.fallback")
      end
    end

    it 'disables and stops iptables service' do
      expect(chef_run).to disable_service('iptables')
      expect(chef_run).to stop_service('iptables')
    end
  end
end
