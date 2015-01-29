#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::foo::params
#
# This class is called from riemann::foo
# It sets platform specific defaults
#
class riemann::foo::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'riemann-foo'
      $service_name = 'riemann-foo'
    }
    'RedHat', 'Amazon': {
      case $::operatingsystemmajrelease {
        '6', '7': {
          $package_name = 'riemann-foo'
          $service_name = 'riemann-foo'
        }
        default: {
          fail("operatingsystemmajrelease `${::operatingsystemmajrelease}` not supported")
        }
      }
    }
    default: {
      fail("osfamily `${::osfamily}` not supported")
    }
  }
}

# vim: ft=puppet
