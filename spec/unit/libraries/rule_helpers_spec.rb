#
# Cookbook:: syslog_ng
# Spec:: config_helpers_spec
#
# Copyright:: 2019, Ben Hughes <bmhughes@bmhughes.co.uk>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

describe 'Iptables::RuleHelpers' do
  let(:dummy_class) { Class.new { include Iptables::RuleHelpers } }
  describe '.comment_builder' do
    context('given string comment') do
      it 'returns string' do
        expect(dummy_class.new.comment_builder(name: 'test', comment: 'test comment')).to be_a(String)
      end

      it 'returns comment as comment' do
        expect(dummy_class.new.comment_builder(name: 'test', comment: 'test comment')).to eql(' -m comment --comment "test comment"')
      end
    end

    context('given TrueClass comment') do
      it 'returns string' do
        expect(dummy_class.new.comment_builder(name: 'test', comment: true)).to be_a(String)
      end

      it 'returns name as comment' do
        expect(dummy_class.new.comment_builder(name: 'test', comment: true)).to eql(' -m comment --comment "test"')
      end
    end

    context('given FalseClass comment') do
      it 'returns string' do
        expect(dummy_class.new.comment_builder(name: 'test', comment: true)).to be_a(String)
      end

      it 'returns empty string' do
        expect(dummy_class.new.comment_builder(name: 'test', comment: false)).to eql('')
      end
    end
  end

  describe '.rule_builder' do
    context('given rule as a line') do
      it 'returns string' do
        expect(dummy_class.new.rule_builder(line: 'test rule')).to be_a(String)
      end

      it 'returns line' do
        expect(dummy_class.new.rule_builder(line: 'test rule')).to eql('test rule')
      end
    end

    context('given rule as parameters') do
      it 'returns string' do
        expect(dummy_class.new.rule_builder(chain: 'INPUT', target: 'ACCEPT')).to be_a(String)
      end

      it 'returns rule strin without match' do
        expect(dummy_class.new.rule_builder(chain: 'INPUT', target: 'ACCEPT')).to eql('-A INPUT -j ACCEPT')
      end

      it 'returns rule strin with match' do
        expect(dummy_class.new
          .rule_builder(
            chain: 'INPUT',
            match: '-m state --state RELATED,ESTABLISHED',
            target: 'ACCEPT')
              ).to eql('-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT')
      end

      it 'returns rule strin with match and extra options' do
        expect(dummy_class.new
          .rule_builder(
            chain: 'LOGGING',
            match: '-m limit --limit 3/sec',
            target: 'LOG',
            extra_options: '--log-prefix "IPtables-Dropped-Input: "')
              ).to eql('-A LOGGING -m limit --limit 3/sec -j LOG --log-prefix "IPtables-Dropped-Input: "')
      end
    end

    context('given no or invalid parameters') do
      it 'raises ArgumentError' do
        expect { dummy_class.new.rule_builder() }.to raise_exception(ArgumentError)
      end
    end
  end

  describe '.comment?' do
    context('given rule with comment') do
      it 'returns true' do
        expect(dummy_class.new.comment_exists?('-A INPUT -p icmp -m comment --comment accept_icmp -j ACCEPT')).to eql(true)
      end
    end

    context('given rule without comment') do
      it 'returns false' do
        expect(dummy_class.new.comment_exists?('-A INPUT -p icmp -j ACCEPT')).to eql(false)
      end
    end

    context('given non string type') do
      it 'raises ArgumentError' do
        expect { dummy_class.new.comment_exists?() }.to raise_exception(ArgumentError)
        expect { dummy_class.new.comment_exists?(nil) }.to raise_exception(ArgumentError)
        expect { dummy_class.new.comment_exists?({}) }.to raise_exception(ArgumentError)
      end
    end
  end
end
