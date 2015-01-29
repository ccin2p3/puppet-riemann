#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::foo::install
#
# This class is called from riemann::foo
# It should provide its package resources
#
class riemann::foo::install {
  package { $riemann::foo::package_name:
    ensure => present,
  }
}
# vim: ft=puppet
