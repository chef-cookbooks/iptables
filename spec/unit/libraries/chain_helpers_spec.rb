#
# Cookbook:: syslog_ng
# Spec:: chain_helpers_spec
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

describe 'Iptables::ChainHelpers' do
  let(:dummy_class) { Class.new { include Iptables::ChainHelpers } }
  describe '.chain_builder' do
    context('given string chain') do
      it 'returns hash' do
        expect(dummy_class.new.chain_builder(chain: 'TEST -')).to be_a(Hash)
        expect(dummy_class.new.chain_builder(chain: 'TEST -')).to eql('TEST' => '-')
        expect(dummy_class.new.chain_builder(chain: 'TEST')).to eql('TEST' => '-')
      end
    end

    context('given string array chain') do
      it 'returns hash' do
        expect(dummy_class.new.chain_builder(chain: ['TEST -'])).to be_a(Hash)
        expect(dummy_class.new.chain_builder(chain: ['TEST -'])).to eql('TEST' => '-')
      end
    end

    context('given hash chain') do
      it 'returns hash' do
        expect(dummy_class.new.chain_builder(chain: { 'TEST' => '-' })).to be_a(Hash)
        expect(dummy_class.new.chain_builder(chain: { 'TEST' => '-' })).to eql('TEST' => '-')
      end
    end

    context('given invalid type') do
      it 'raises ArgumentError' do
        expect { dummy_class.new.chain_builder(chain: nil) }.to raise_exception(ArgumentError)
        expect { dummy_class.new.chain_builder(chain: 0) }.to raise_exception(ArgumentError)
      end
    end

    context('given invalid string chain') do
      it 'raises ArgumentError' do
        expect { dummy_class.new.chain_builder(chain: 'TEST 0') }.to raise_exception(ArgumentError)
      end
    end
  end

  describe '.chain_definition_valid?' do
    context('given valid chain') do
      it 'returns true' do
        expect(dummy_class.new.chain_definition_valid?('TEST - [0:0]')).to eql(true)
        expect(dummy_class.new.chain_definition_valid?('TEST2 ACCEPT [0:0]')).to eql(true)
        expect(dummy_class.new.chain_definition_valid?('TEST3 DROP')).to eql(true)
      end
    end

    context('given malformed chain') do
      it 'returns false' do
        expect(dummy_class.new.chain_definition_valid?('TEST')).to eql(false)
        expect(dummy_class.new.chain_definition_valid?('TEST2- [0:0]')).to eql(false)
        expect(dummy_class.new.chain_definition_valid?('TEST3 DROP 0')).to eql(false)
      end
    end

    context('given non string type') do
      it 'raises ArgumentError' do
        expect { dummy_class.new.chain_definition_valid?() }.to raise_exception(ArgumentError)
        expect { dummy_class.new.chain_definition_valid?(nil) }.to raise_exception(ArgumentError)
        expect { dummy_class.new.chain_definition_valid?({}) }.to raise_exception(ArgumentError)
      end
    end
  end

  describe '.chain_exists?' do
    context('given existent chain') do
      it 'returns true' do
        expect(dummy_class.new.chain_exists?(chainhash: { 'INPUT' => 'ACCEPT [0:0]' }, chain: 'INPUT')).to eql(true)
        expect(dummy_class.new.chain_exists?(chainhash: { 'INPUT' => 'ACCEPT [0:0]' }, chain: { 'INPUT' => '' })).to eql(true)
        expect(dummy_class.new.chain_exists?(chainhash: { 'INPUT' => 'ACCEPT [0:0]' }, chain: [ 'INPUT' ])).to eql(true)
      end
    end

    context('given nonexistent chain') do
      it 'returns false' do
        expect(dummy_class.new.chain_exists?(chainhash: { 'INPUT' => 'ACCEPT [0:0]' }, chain: 'LOGGING')).to eql(false)
        expect(dummy_class.new.chain_exists?(chainhash: { 'INPUT' => 'ACCEPT [0:0]' }, chain: { 'LOGGING' => '-' })).to eql(false)
        expect(dummy_class.new.chain_exists?(chainhash: { 'INPUT' => 'ACCEPT [0:0]' }, chain: [ 'LOGGING -' ])).to eql(false)
      end
    end

    context('given invalid type') do
      it 'raises ArgumentError' do
        expect { dummy_class.new.chain_exists?(chainhash: nil, chain: nil) }.to raise_exception(ArgumentError)
      end
    end
  end
end
