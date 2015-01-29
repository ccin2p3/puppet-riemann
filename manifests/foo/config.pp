#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::foo::config
#
# This class is called from riemann::foo
# It should provide its configuration resources
#
class riemann::foo::config {
  file { '/etc/riemann':
    ensure => directory
  } ->
  file { '/etc/riemann/foo.conf':
    ensure  => present,
    content => template('riemann/foo.conf.erb')
  }
}
# vim: ft=puppet
