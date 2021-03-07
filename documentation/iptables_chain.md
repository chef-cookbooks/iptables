[Back to resource list](https://github.com/chef-cookbooks/iptables/tree/master/README.md#resources)

---

# iptables_chain

The `iptables_chain` resource can be used to manage configuration of chains for iptables.

More information available at <hhttps://linux.die.net/man/8/iptables>

As this is an accumalator pattern resource not declaring a chain will have it removed unless it is a default chain

## Actions

- `:create`
- `:delete`

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
| `ip_version`                  | `Symbol`, `String` | `:ipv4` | The IP version | `:ipv4`, `:ipv6` |
| `table`              | `Symbol`       | `:filter` | The table the chain should exist on | `:filter`, `:mangle`, `:nat`, `:raw`, `:security` |
| `chain`         | `Symbol`      | `nil` | The name of the Chain | |
| `value`                     | `String`      | `ACCEPT [0:0]` | The default action and the Packets : Bytes count | |

## Examples

Create the `filter` table default chain

```ruby
iptables_chain 'filter' do
  table :filter
end
```

Create a custom chain

```ruby
iptables_chain 'filter' do
  table :filter
  chain :LOGGING
  value '- [0:0]'
end
```
