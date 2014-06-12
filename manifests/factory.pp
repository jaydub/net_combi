# = Type: net_combi::factory
#
# A factory class that pulls data from the net_combi_entries key in
# hiera, and  uses it to create a set of net_combi::entry  resources.
class net_combi::factory
(
  $hiera_key = 'net_combi_entries',
  $resource_type = 'net_combi::entry',
  $resource_creation = 'default'
)
{
  case $resource_creation {
    'export':  { $qualified_resource_type = "@@${resource_type}" }
    'virtual': { $qualified_resource_type = "@${resource_type}" }
    default:   { $qualified_resource_type = $resource_type }
  }
  create_resources($qualified_resource_type, hiera($hiera_key, {}))
}
