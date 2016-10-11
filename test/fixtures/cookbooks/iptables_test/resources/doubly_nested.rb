provides :doubly_nested
resource_name :doubly_nested

property :name, kind_of: String, name_attribute: true
property :source, kind_of: String, default: nil
property :cookbook, kind_of: String, default: nil
property :variables, kind_of: Hash, default: {}
property :lines, kind_of: String, default: nil

default_action :doit

action :doit do
  nested new_resource.name do
    source new_resource.source
    cookbook new_resource.cookbook
    variables new_resource.variables
    lines new_resource.lines
  end
end
