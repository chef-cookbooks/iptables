name              "iptables"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Sets up iptables to use a script to maintain rules"
version           "0.13.1"

recipe "iptables", "Installs iptables and sets up .d style config directory of iptables rules"
%w{redhat centos debian ubuntu amazon}.each do |os|
  supports os
end
