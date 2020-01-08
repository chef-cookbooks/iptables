#
# Author:: Ben Hughes <bmhughes@bmhughes.co.uk>
# Cookbook:: iptables
# Resource:: chain6
#
# Copyright:: 2019, Ben Hughes
# Copyright:: 2017-2019, Chef Software, Inc.
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

property :source, String
property :cookbook, String
property :config_file, String, default: lazy { node['iptables']['persisted_rules_ip6tables'] }
property :table, String, equal_to: %w(filter mangle nat raw security), default: 'filter'
property :chain, [String, Array, Hash]
property :filemode, [String, Integer], default: '0644'

action :create do
  iptables_chain new_resource.name do
    source new_resource.source
    cookbook new_resource.cookbook
    config_file new_resource.config_file
    table new_resource.table
    chain new_resource.chain
    filemode new_resource.filemode
    sensitive new_resource.sensitive
    action :create
  end
end
