name 'iptables'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs the iptables daemon and provides a LWRP for managing rules'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.1'

recipe 'default', 'Installs iptables and sets up .d style config directory of iptables rules'

%w(redhat centos debian ubuntu amazon scientific oracle amazon).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/iptables' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/iptables/issues' if respond_to?(:issues_url)
