# = Type: net_combi::tinydns_host_collector
#
# tinydns host entry resource collector as a class suitable for
# ENC inclusion.
#
class net_combi::tinydns_host_collector () {
  Dbndns::Tinydns_host <<| |>>
}
