#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::config
#
# This class is called from riemann
# It should include common resource classes
#  e.g. configuration Files
#
class riemann::config {
  file { "/etc/riemann.conf":
    ensure  => present,
    content => template('riemann/conf.erb'),
  }
}
# vim: ft=puppet
