apt_update

include_recipe 'iptables::default'

iptables_rule 'sshd'

iptables_rule6 'sshd'
