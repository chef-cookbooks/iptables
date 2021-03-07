#
# Cookbook:: iptables
# Library:: resource
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

require_relative 'template'

module Iptables
  module Cookbook
    module ResourceHelpers
      include Iptables::Cookbook::TemplateHelpers

      IPTABLES_RULE_PROPERTIES ||= {
        chain: '-A',
        protocol: '-p',
        match: '-m',
        source: '-s',
        destination: '-d',
        jump: '-j',
        go_to: '-g',
        in_interface: '-i',
        out_interface: '-o',
        fragment: '-f',
        comment: '-m comment --comment',
        extra_options: nil,
      }.freeze

      def rulefile_resource_init
        rulefile_resource_create unless rulefile_resource_exist?
      end

      def rulefile_resource
        return false unless rulefile_resource_exist?

        find_resource(:template, new_resource.config_file)
      end

      def rule_builder
        return new_resource.line unless nil_or_empty?(new_resource.line)

        IPTABLES_RULE_PROPERTIES.map do |property, prefix|
          next if nil_or_empty?(new_resource.send(property))

          nil_or_empty?(prefix) ? new_resource.send(property) : "#{prefix} #{new_resource.send(property)}"
        end.compact.join(' ')
      end

      private

      def rulefile_resource_exist?
        !find_resource(:template, new_resource.config_file).nil?
      rescue Chef::Exceptions::ResourceNotFound
        false
      end

      def rulefile_resource_create
        with_run_context(:root) do
          edit_resource(:template, new_resource.config_file) do |new_resource|
            owner new_resource.owner
            group new_resource.group
            mode new_resource.mode

            source new_resource.template
            cookbook new_resource.cookbook
            sensitive new_resource.sensitive

            variables[:iptables] ||= {}

            Iptables::Cookbook::Helpers::IPTABLES_TABLE_NAMES.each do |table|
              variables[:iptables][table] ||= {}
              variables[:iptables][table][:chains] ||= default_chains_for_table(table)
              variables[:iptables][table][:rules] ||= []
            end

            helpers(Iptables::Cookbook::TemplateHelpers)

            action :nothing
            delayed_action :create
          end
        end
      end
    end
  end
end
