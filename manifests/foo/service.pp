#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::foo::service
#
# This class is called from riemann::foo
# It ensures the foo service is running
#
class riemann::foo::service {
  service { $riemann::foo::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
# vim: ft=puppet
