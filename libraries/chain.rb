#
# Cookbook:: iptables
# Library:: chain
#
# Copyright:: 2019, Chef Software, Inc.
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
#

module Iptables
  module ChainHelpers
    def chain_builder(chain:)
      chainhash = {}

      case chain
      when Hash
        Chef::Log.info("Adding chain hash '#{chain}'")
        raise ArgumentError, "Invalid chain format '#{chain}' specified" unless chain_definition_valid?(chain.flatten.join(' '))
        chainhash = chain
      when Array
        Chef::Log.info("Adding chain array '#{chain}'")
        chain.each do |chn|
          chainhash.update(chain_builder(chain: chn))
        end
      when String
        Chef::Log.info("Adding chain string '#{chain}'")

        if chain_definition_valid?(chain)
          chainstring = chain.upcase
        elsif chain.match?(/^(\w+)$/)
          chainstring = chain.upcase.concat(' -')
        else
          raise ArgumentError, "Invalid chain format '#{chain}' specified"
        end

        chainhash[chainstring.partition(' ').first] = chainstring.partition(' ').last
      else
        raise ArgumentError, "Invalid class '#{chain.class}' given"
      end

      chainhash
    end

    def chain_definition_valid?(chain)
      raise ArgumentError unless chain.is_a?(String)
      Chef::Log.info("Validating iptables chain definition: #{chain}")
      chain.match?(/^((\w+) (-|[a-zA-Z]+))$|^((\w+) (-|[a-zA-Z]+) (\[\d+\:\d+\]))$/)
    end

    def chain_exists?(chainhash:, chain:)
      case chain
      when Hash, Array
        chainname = chain.flatten.first
      when String
        chainname = chain.partition(' ').first
      else
        raise ArgumentError, "Chain passed as an invalid class, '#{chain.class}' given. Should be Hash, Array or String."
      end
      Chef::Log.info("Check whether iptables chain #{chainname} exists in #{chainhash}")
      result = chainhash.key?(chainname)
      Chef::Log.info('Chain exists') if result
      Chef::Log.info('Chain missing') unless result

      result
    end
  end
end
