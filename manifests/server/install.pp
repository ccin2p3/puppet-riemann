#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::server::install
#
# This class is called from riemann::server
# It should provide its package resources
#
class riemann::server::install {
  package { $riemann::server::package_name:
    ensure => present,
  }
}
# vim: ft=puppet
