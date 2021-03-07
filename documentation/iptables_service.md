[Back to resource list](https://github.com/chef-cookbooks/iptables/tree/master/README.md#resources)

---

# iptables_service

The `iptables_service` resource can be used to configure the required service for iptables for autoreloading.

## Actions

- `:start`
- `:stop`
- `:restart`
- `:reload`
- `:enable`
- `:disable`

## Properties

| Name                            | Type        |  Default | Description | Allowed Values |
--------------------------------- | ----------- | -------- | ----------- | -------------- |
| `config_file`          | `String`     | The default location on disk of the config file, see resource for details | The full path to find the rules on disk | |
| `owner`            | `String`     | `root` | Owner of the saved output file | |
| `group`            | `String`     | `root` | Group of the saved output file | |
| `mode`            | `String`     | `0644` | Permissions on the saved output file | |
| `template`                       | `source_template`      | `iptables.erb` | Source template to use to create the rules | |
| `cookbook`               | `String`      | `iptables` | Source cookbook to find the template in | |
| `sensitive`               | `true, false`      | `false` | mark the resource as senstive | |
| `ip_version`                  | `Symbol`, `String`      | `:ipv4` | The IP version | `:ipv4`, `:ipv6` |
| `service_name`   | `String` | Correct service name | Name of the iptables services | |
| `owner`            | `String`     | `root` | Owner of the saved output file | |
| `group`            | `String`     | `root` | Group of the saved output file | |
| `mode`            | `String`     | `0644` | Permissions on the saved rules file | |
| `template`                       | `source_template`      | `iptables.erb` | Source template to use to create the rules | |
| `cookbook`               | `cookbook`      | `iptables` | Source cookbook to find the template in | |
| `sysconfig_file`          | `String`     | The default location on disk of the sysconfig file, see resource for details | The full path to find the sysconfig file on disk | |
| `sysconfig_template`                       | `source_template`      | `iptables-config.erb` | Source template to use to create the rules | |
| `sysconfig`   | `Hash` | Correct default settings | A hash of the config settings for sysconfig, see library for more details | |

## Examples

Service configuration for ipv4

```ruby
iptables_service 'iptables services ipv4' do
end
```

service configuration for ipv6

```ruby
iptables_service 'iptables services ipv4' do
  ip_version :ipv6
end

```
