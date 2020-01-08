# iptables Cookbook

[![CI State](https://github.com/chef-cookbooks/iptables/workflows/ci/badge.svg)](https://github.com/chef-cookbooks/iptables/actions?query=workflow%3Aci)
[![Cookbook Version](https://img.shields.io/cookbook/v/iptables.svg)](https://supermarket.chef.io/cookbooks/iptables)

Installs iptables and provides a custom resource for adding and removing iptables rules

## Requirements

### Platforms

- Ubuntu/Debian
- RHEL/CentOS and derivatives
- Amazon Linux

### Chef

- Chef 12.15+

### Cookbooks

- none

## Recipes

### default

The default recipe will install iptables and provides a pair of resources for managing firewall rules for both `iptables` and `ip6tables`.

### disabled

The disabled recipe will install iptables, disable the `iptables` service (on RHEL platforms), and flush the current `iptables` and `ip6tables` rules.

## Attributes

`default['iptables']['iptables_sysconfig']` and `default['iptables']['ip6tables_sysconfig']` are hashes that are used to template /etc/sysconfig/iptables-config and /etc/sysconfig/ip6tables-config. The keys must be upper case and any key / value pair included will be added to the config file.

`default['iptables']['persisted_rules_iptables']` and `default['iptables']['persisted_rules_ip6tables']` are strings that are used to hold the location of the generated `iptables-save`/`iptables-restore` format file containing the firewall rules for the system.

`default['iptables']['persisted_rules_template']` is a hash that contains the base structure for the generated persisted rule files containing the default tables and chains.

## Custom Resource

### chain

Use this resource to create ip(6)tables chains that can be later referenced in rules, this resource contains the same accumulated template resource that the rule resource does but only deals with the creation of chains.

| Property          | Optional? | Type                | Description                                                                  |
|-------------------|-----------|---------------------|------------------------------------------------------------------------------|
| `source`          | Yes       | String              | Source template for the generation of the persistent rules file              |
| `cookbook`        | Yes       | String              | Source cookbook for the generation of the persistent rules file              |
| `config_file`     | Yes       | String              | Persistent rules file to generate                                            |
| `table`           | Yes       | String              | The iptables table to create the chain on (defaults to `filter`)             |
| `chain`           | No        | String, Array, Hash | The chain name and optionally default action and packet counts               |
| `filemode`        | Yes       | String, Integer     | Filemode of the the persistent rules file                                    |

The `chain` property accepts entries in the following formats:

#### Chain without default action and packet counts (in this case default action will be set to `-`)

##### String

```ruby
'NEWCHAIN'
```

##### Array of String

```ruby
['NEWCHAIN1', 'NEWCHAIN2', 'NEWCHAIN3']
```

##### Hash

```ruby
{ 'NEWCHAIN' => ''}
```

#### Chain with default action but no packet counts

##### String

```ruby
'NEWCHAIN -'
```

##### Array of String

```ruby
['NEWCHAIN1 ACCEPT', 'NEWCHAIN2 REJECT', 'NEWCHAIN3 DROP']
```

##### Hash

```ruby
{ 'NEWCHAIN' => 'DROP'}
```

#### Chain with default action and packet counts

##### String

```ruby
'NEWCHAIN ACCEPT [123:123]'
```

##### Array of String

```ruby
['NEWCHAIN1 ACCEPT [0:0]', 'NEWCHAIN2 REJECT [1:1]', 'NEWCHAIN3 DROP [322:322]']
```

##### Hash

```ruby
{ 'NEWCHAIN' => 'DROP [0:0]'}
```

### chain6

The `iptables_chain6` provides IPv6 support with the same behavior as the original `iptables_chain`.

### rule

The custom resource contains an accumulated template resource which generates the persisted rule file which notifies the reload of the firewall rules at the end of the chef run. See **Examples** below.

NOTE: In the 5.0 release of this cookbook the iptables_rule definition was converted to an accumulated template resource. This changes the behavior of disabling iptables rules. Previously a rule needed to be disabled explicitly by calling the resource with `:disable`. Now as soon as a rule resource is no longer included in the chef run it will not be added to the accumulated template and will be automatically removed.

| Property          | Optional? | Type                | Description                                                                              |
|-------------------|-----------|---------------------|------------------------------------------------------------------------------------------|
| `source`          | Yes       | String              | Source template for the generation of the persistent rules file                          |
| `cookbook`        | Yes       | String              | Source cookbook for the generation of the persistent rules file                          |
| `config_file`     | Yes       | String              | Persistent rules file to generate                                                        |
| `table`           | Yes       | String              | The iptables table to create the chain on (defaults to `filter`)                         |
| `chain`           | No (1)    | String              | The chain name to be used if the rule is generated from properties                       |
| `match`           | Yes       | String              | The match settings for the rule                                                          |
| `target`          | No (1)    | String              | The target for the rule                                                                  |
| `line`            | No (2)    | String              | A string containing a complete  iptables rule statement, no generation takes place       |
| `comment`         | Yes       | String, True, False | The comment for the rule if a string, use resource name if `true`, no comment if `false` |
| `extra_options`   | Yes       | String              | Extra options to appended to the rule after the destination `-j XXXXX`                   |
| `filemode`        | Yes       | String, Integer     | Filemode of the the persistent rules file                                                |

**The resource can be called with one of two property sets:**

  1. `chain` and `target` are set (`match` optionally), in which case `line` is ignored.
  2. `chain` and `target` are unset in which case `line` used.

### rule6

The `iptables_rule6` provides IPv6 support with the same behavior as the original `iptable_rule`.

## Usage

Add `recipe[iptables]` to your runlist to ensure iptables is installed and running on the system. Then create use `iptables_rule`/`ip6tables_rule` to add individual rules. See **Examples**.

Since certain chains can be used with multiple tables (e.g., _PREROUTING_), you might have to include the name of the table explicitly using the `table` property (i.e., _*nat_, _*mangle_, etc.), so that the resource can infer how to assemble the final ruleset file that is going to be loaded. Please note, that unless specified otherwise, rules will be added under the **filter** table by default.

### Examples

To enable port 80, e.g. in an `my_httpd` cookbook, create the following rule resource:

```ruby
# Port 80 for http
iptables_chain 'fwr' do
  chain 'FWR'
end

iptables_rule 'httpd' do
  line '-A FWR -p tcp -m tcp --dport 80 -j ACCEPT'
end
```

or to generate:

```ruby
# Port 80 for http
iptables_chain 'fwr' do
  chain 'FWR'
end

iptables_rule 'httpd' do
  chain 'FWR'
  match '-p tcp -m tcp --dport 80'
  target 'ACCEPT'
end
```

To redirect port 80 to local port 8080, e.g., in the aforementioned `my_httpd` cookbook, create the following rule resource:

```ruby
# Redirect anything on eth0 coming to port 80 to local port 8080
iptables_rule 'httpd' do
  table 'nat'
  chain 'PREROUTING'
  match '-i eth0 -p tcp --dport 80'
  target 'REDIRECT'
  extra_options '--to-port 8080'
end
```

To create a rule without using the `line` property (you can optionally specify `table` when using `line`):

```ruby
iptables_rule 'http_8080' do
  line '-A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080'
  table 'nat'
end
```

Additionally, a rule can be marked as sensitive so it's contents does not get output to the the console or logged with the sensitive property set to `true`. The mode of the generated rule file can be set with the filemode property:

```ruby
iptables_rule 'http_8080' do
  line '-A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080'
  table 'nat'
  sensitive true
end
```

```ruby
iptables_rule 'http_8080' do
  line '-A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080'
  table 'nat'
  sensitive true
  filemode '0600'
end
```

To get attribute-driven rules you can (for example) feed a hash of attributes into named iptables.d files like this:

```ruby
node.default['iptables']['rules']['http_80'] = '-A FWR -p tcp -m tcp --dport 80 -j ACCEPT'
node.default['iptables']['rules']['http_443'] = [
  '# an example with multiple lines',
  '-A FWR -p tcp -m tcp --dport 443 -j ACCEPT',
]

node['iptables']['rules'].map do |rule_name, rule_body|
  iptables_rule rule_name do
    line [ rule_body ].flatten.join("\n")
  end
end
```

## License & Authors

**Author:** Cookbook Engineering Team ([cookbooks@chef.io](mailto:cookbooks@chef.io))

**Copyright:** 2008-2019, Chef Software, Inc.

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
