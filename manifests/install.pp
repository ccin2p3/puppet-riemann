#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::install
#
# This class is called from riemann
# It ensures Package resources are present
#
class riemann::install {
  package { $riemann::package_name:
    ensure => present,
  }
}
# vim: ft=puppet
