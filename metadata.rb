name              'iptables'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache-2.0'
description       'Installs the iptables daemon and provides resources for managing rules'
version           '7.0.0'
chef_version      '>= 14'

%w(redhat centos debian ubuntu amazon scientific oracle amazon zlinux).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/iptables'
issues_url 'https://github.com/chef-cookbooks/iptables/issues'
