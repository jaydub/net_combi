# = Type: net_combi::dhcp_host_collector
#
# DHCP host reservation resoruce collector as a class suitable for
# ENC inclusion.
#
class net_combi::dhcp_host_collector () {
  Dhcp::Host <<| |>>
}
