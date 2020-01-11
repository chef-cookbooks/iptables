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
  module Cookbook
    module Helpers
      def default_iptables_rules_file(ip_version)
        # This function will look at the node platform
        # and return the correct file on disk location for the config file
        case ip_version
        when :ipv4
          case node['platform_family']
          when 'rhel', 'fedora', 'amazon'
            '/etc/sysconfig/iptables'
          when 'debian'
            '/etc/iptables/rules.v4'
          end
        when :ipv6
          case node['platform_family']
          when 'rhel', 'fedora', 'amazon'
            '/etc/sysconfig/ip6tables'
          when 'debian'
            '/etc/iptables/rules.v6'
          end
        else
          raise "#{ip_version} is unknown"
        end
      end

      def get_default_chains_for_table(table_name)
        # This function will take in a table and look for default chains
        # that should exist for that table, it will then return a structured hash
        # of those chains
        case table_name
        when :filter
          {
            INPUT: { value: 'ACCEPT [0:0]' },
            FORWARD: { value: 'ACCEPT [0:0]' },
            OUTPUT: { value: 'ACCEPT [0:0]' },
          }
        when :mangle
          {
            PREROUTING: { value: 'ACCEPT [0:0]' },
            INPUT: { value: 'ACCEPT [0:0]' },
            FORWARD: { value: 'ACCEPT [0:0]' },
            OUTPUT: { value: 'ACCEPT [0:0]' },
            POSTROUTING: { value: 'ACCEPT [0:0]' },
          }
        when :nat
          {
            PREROUTING: { value: 'ACCEPT [0:0]' },
            OUTPUT: { value: 'ACCEPT [0:0]' },
            POSTROUTING: { value: 'ACCEPT [0:0]' },
          }
        when :raw
          {
            PREROUTING: { value: 'ACCEPT [0:0]' },
            OUTPUT: { value: 'ACCEPT [0:0]' },
          }
        when :security
          {
            INPUT: { value: 'ACCEPT [0:0]' },
            FORWARD: { value: 'ACCEPT [0:0]' },
            OUTPUT: { value: 'ACCEPT [0:0]' },
          }
        else
          {}
        end
      end
    end
  end
end
