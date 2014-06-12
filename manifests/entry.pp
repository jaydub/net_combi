# Exporting each type internally means that they are individually available
# outside of this type's containment, so eg regular hosts can realise arp
# and hosts, while the dhcp and dns servers can also realise the dhcp and
# dns entries.

define net_combi::entry (
  $mac='',
  $ip='',
  $fqdn=$title,
  $aliases=[],
  $domain='',
  $resource_creation = 'export'
)
{
  $norm_domain = regsubst($domain, '^[^\.].+', ".\0")
  $fqdn_aliases = suffix($aliases, $norm_domain)
  $tinydns_aliases = delete($fqdn_aliases, $fqdn)

  # BUG: Work around pass by reference brain damage in the paser function
  # interface that results in eg concat modifying it's input as a
  # side effect. 
  $ablative_tinydns_aliases =  suffix($tinydns_aliases, '')
  $host_aliases = concat($ablative_tinydns_aliases, $aliases)

  $static_arp_data = {
    "${fqdn}" => {
      ip  => $ip,
      mac => $mac
      }
  }
  $host_data = {
    "${fqdn}" => {
      ip => $ip,
      host_aliases => $host_aliases
      }
  }
  $tinydns_data = {
    "${fqdn}" => {
      ip => $ip,
      fqdn_aliases => $tinydns_aliases
      }
  }

  case $resource_creation {
    'export':  {$prefix = '@@'}
    'virtual': {$prefix = '@'}
    default:   {$prefix = ''}
  }
  validate_array($tinydns_aliases)
  create_resources("${prefix}static_arp::entry", $static_arp_data)
  create_resources("${prefix}host", $host_data)
  # host reservations use the same data as static arp entries.
  create_resources("${prefix}dhcp::host", $static_arp_data)
  create_resources("${prefix}dbndns::tinydns_host", $tinydns_data)
}
