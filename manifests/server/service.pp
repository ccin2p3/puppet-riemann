#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::server::service
#
# This class is called from riemann::server
# It ensures the server service is running
#
class riemann::server::service {
  service { $riemann::server::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
  exec { 'riemann_server_reload':
    path        => [ '/bin', '/usr/bin' ],
    command     => $riemann::server::reload_command,
    refreshonly => true,
  }
}
# vim: ft=puppet
