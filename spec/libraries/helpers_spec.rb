require 'spec_helper'

RSpec.describe Iptables::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Iptables::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#get_package_names' do
    before do
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
    end

    context 'When platform family is debian' do
      let(:platform_family) { 'debian' }

      it 'returns the correct packages' do
        expect(subject.get_package_names()).to match(%w(iptables iptables-persistent))
      end
    end

    %w(rhel fedora amazon).each do |platform|
      context "When platform family is #{platform}" do
        let(:platform_family) { platform }

        it 'returns the correct packages' do
          expect(subject.get_package_names()).to match(%w(iptables iptables-services iptables-utils))
        end
      end
    end
  end

  describe '#default_iptables_rules_file' do
    before do
      allow(subject).to receive(:[]).with('ip_version').with('platform_family').and_return(ip_version).and_return(platform_family)
    end
    context 'When given an ipv4 on rhel' do
      let(:ip_version) { :ipv4 }
      let(:platform_family) { 'rhel' }

      it 'returns the correct path' do
        expect(subject.default_iptables_rules_file(ip_version)).to match('/etc/sysconfig/iptables')
      end
    end
    context 'When given an ipv6 on rhel' do
      let(:ip_version) { :ipv6 }
      let(:platform_family) { 'rhel' }

      it 'returns the correct path' do
        expect(subject.default_iptables_rules_file(ip_version)).to match('/etc/sysconfig/ip6tables')
      end
    end

    context 'When given an ipv4 on amazon' do
      let(:ip_version) { :ipv4 }
      let(:platform_family) { 'amazon' }

      it 'returns the correct path' do
        expect(subject.default_iptables_rules_file(ip_version)).to match('/etc/sysconfig/iptables')
      end
    end

    context 'When given an ipv6 on amazon' do
      let(:ip_version) { :ipv6 }
      let(:platform_family) { 'amazon' }

      it 'returns the correct path' do
        expect(subject.default_iptables_rules_file(ip_version)).to match('/etc/sysconfig/ip6tables')
      end
    end

    context 'When given an ipv4 on fedora' do
      let(:ip_version) { :ipv4 }
      let(:platform_family) { 'fedora' }

      it 'returns the correct path' do
        expect(subject.default_iptables_rules_file(ip_version)).to match('/etc/sysconfig/iptables')
      end
    end

    context 'When given an ipv6 on fedora' do
      let(:ip_version) { :ipv6 }
      let(:platform_family) { 'fedora' }

      it 'returns the correct path' do
        expect(subject.default_iptables_rules_file(ip_version)).to match('/etc/sysconfig/ip6tables')
      end
    end

    context 'When given an ipv4 on debian' do
      let(:ip_version) { :ipv4 }
      let(:platform_family) { 'debian' }

      it 'returns the correct path' do
        expect(subject.default_iptables_rules_file(ip_version)).to match('/etc/iptables/rules.v4')
      end
    end

    context 'When given an ipv6 on debian' do
      let(:ip_version) { :ipv6 }
      let(:platform_family) { 'debian' }

      it 'returns the correct path' do
        expect(subject.default_iptables_rules_file(ip_version)).to match('/etc/iptables/rules.v6')
      end
    end
  end

  describe '#get_default_chains_for_table' do
    before do
      allow(subject).to receive(:[]).with('table_name').and_return(table_name)
    end
    context 'When given an unknown table' do
      let(:table_name) { :does_not_exist }

      it 'returns an empty Hash' do
        expect(subject.get_default_chains_for_table(table_name)).to eq({})
      end
    end
    context 'When given the table filter' do
      let(:table_name) { :filter }

      it 'returns the correct default chains' do
        expect(subject.get_default_chains_for_table(table_name)).to include(
          INPUT: 'ACCEPT [0:0]',
          FORWARD: 'ACCEPT [0:0]',
          OUTPUT: 'ACCEPT [0:0]'
        )
      end
    end
    context 'When given the table mangle' do
      let(:table_name) { :mangle }

      it 'returns the correct default chains' do
        expect(subject.get_default_chains_for_table(table_name)).to include(
          PREROUTING: 'ACCEPT [0:0]',
          INPUT: 'ACCEPT [0:0]',
          FORWARD: 'ACCEPT [0:0]',
          OUTPUT: 'ACCEPT [0:0]',
          POSTROUTING: 'ACCEPT [0:0]'
        )
      end
    end
    context 'When given the table nat' do
      let(:table_name) { :nat }

      it 'returns the correct default chains' do
        expect(subject.get_default_chains_for_table(table_name)).to include(
          PREROUTING: 'ACCEPT [0:0]',
          OUTPUT: 'ACCEPT [0:0]',
          POSTROUTING: 'ACCEPT [0:0]'
        )
      end
    end

    context 'When given the table raw' do
      let(:table_name) { :raw }

      it 'returns the correct default chains' do
        expect(subject.get_default_chains_for_table(table_name)).to include(
          PREROUTING: 'ACCEPT [0:0]',
          OUTPUT: 'ACCEPT [0:0]'
        )
      end
    end

    context 'When given the table security' do
      let(:table_name) { :security }

      it 'returns the correct default chains' do
        expect(subject.get_default_chains_for_table(table_name)).to include(
          INPUT: 'ACCEPT [0:0]',
          FORWARD: 'ACCEPT [0:0]',
          OUTPUT: 'ACCEPT [0:0]'
        )
      end
    end
  end
end
