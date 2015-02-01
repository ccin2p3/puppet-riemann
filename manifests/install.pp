#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::install
#
# This class is called from riemann
# It should provide its package resources
#
class riemann::install {
  package { $riemann::package_name:
    ensure => present,
  }
}
# vim: ft=puppet
