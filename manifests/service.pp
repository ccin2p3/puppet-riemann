#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::service
#
# This class is called from riemann
# It ensures the server service is running
#
class riemann::service {
  service { $riemann::service_name:
    ensure     => running,
    enable     => true,
    restart    => $riemann::reload_command,
    hasstatus  => true,
    hasrestart => true,
  }
}
# vim: ft=puppet
