#
# Cookbook:: iptables
# Recipe:: default
#
# Copyright:: 2008-2019, Chef Software, Inc.
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

include_recipe 'iptables::_package'

%w(iptables ip6tables).each do |ipt|
  case node['platform_family']
  when 'debian'
    # debian based systems load iptables during the interface activation
    template "/etc/network/if-pre-up.d/#{ipt}_load" do
      source 'iptables_load.erb'
      mode '0755'
      variables(
        iptables_save_file: node['iptables']["persisted_rules_#{ipt}"],
        iptables_restore_binary: "/sbin/#{ipt}-restore"
      )
    end

    file = node['iptables']["persisted_rules_#{ipt}"]
    execute "reload #{ipt}" do
      command "/etc/network/if-pre-up.d/#{ipt}_load"
      subscribes :run, "template[#{file}]", :delayed
      action :nothing
    end
  when 'rhel', 'fedora', 'amazon'
    # iptables service exists only on RHEL based systems
    file "/etc/sysconfig/#{ipt}" do
      content '# Chef managed placeholder to allow iptables service to start'
      action :create_if_missing
    end

    template "/etc/sysconfig/#{ipt}-config" do
      source 'iptables-config.erb'
      mode '600'
      variables(
        config: node['iptables']["#{ipt}_sysconfig"]
      )
    end

    file = node['iptables']["persisted_rules_#{ipt}"]
    service ipt do
      supports status: true, start: true, stop: true, restart: true, reload: true
      subscribes :restart, "template[#{file}]", :delayed
      action [:enable, :start]
    end
  end
end
