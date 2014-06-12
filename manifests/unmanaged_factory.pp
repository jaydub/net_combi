# = Type: net_combi::unmanaged_factory
#
# A factory class that pulls data from the net_combi_unmanaged_entries key in
# hiera, and  uses it to create a set of net_combi::entry  resources.
class net_combi::unmanaged_factory
(
  $hiera_key = 'net_combi_unmanaged_entries',
  $resource_type = 'net_combi::entry',
  $resource_creation = 'default'
)
{
  case $resource_creation {
    'export':  {create_resources("@@${resource_type}", hiera($hiera_key, {}))}
    'virtual': {create_resources("@${resource_type}", hiera($hiera_key, {}))}
    default:   {create_resources($resource_type, hiera($hiera_key, {}))}
  }
}
