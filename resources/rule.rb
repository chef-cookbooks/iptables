#
# Author:: Ben Hughes <bmhughes@bmhughes.co.uk>
# Cookbook:: iptables
# Resource:: rule
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

property :source, String, default: 'iptables.erb'
property :cookbook, String, default: 'iptables'
property :config_file, String, default: lazy { node['iptables']['persisted_rules_iptables'] }
property :table, String, equal_to: %w(filter mangle nat raw security), default: 'filter'
property :chain, String
property :match, String
property :target, String
property :line, String
property :comment, [String, TrueClass, FalseClass], default: true
property :extra_options, String
property :filemode, [String, Integer], default: '0644'

action :create do
  Chef::Resource::Template.send(:include, Iptables::RuleHelpers)
  Chef::Resource::Template.send(:include, Iptables::ChainHelpers)

  with_run_context :root do
    edit_resource(:template, new_resource.config_file) do |new_resource|
      source new_resource.source
      cookbook new_resource.cookbook
      sensitive new_resource.sensitive
      mode new_resource.filemode

      variables['iptables'] ||= {}
      variables['iptables'][new_resource.table] ||= node['iptables']['persisted_rules_template'][new_resource.table].dup

      variables['iptables'][new_resource.table]['rules'] ||= []
      unless new_resource.line.nil? && new_resource.chain.nil? && new_resource.match.nil? && new_resource.target.nil?
        rule = rule_builder(
          line: new_resource.line,
          chain: new_resource.chain,
          match: new_resource.match,
          target: new_resource.target,
          extra_options: new_resource.extra_options)

        rule.concat(comment_builder(name: new_resource.name, comment: new_resource.comment)) unless comment_exists?(rule)

        Chef::Log.info("Running accumulator template resource for rule '#{rule}' and file #{new_resource.config_file}")
        variables['iptables'][new_resource.table]['rules'] << rule
      end

      action :nothing
      delayed_action :create
    end
  end
end
