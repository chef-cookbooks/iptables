name 'iptables'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs the iptables daemon and provides a LWRP for managing rules'
version '6.0.1'
chef_version '>= 12.15'

%w(redhat centos debian ubuntu amazon scientific oracle amazon zlinux).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/iptables'
issues_url 'https://github.com/chef-cookbooks/iptables/issues'
