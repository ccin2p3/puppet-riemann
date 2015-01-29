#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::params
#
# This class is called from riemann
# It sets platform specific defaults
#
class riemann::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'riemann'
      $service_name = 'riemann'
    }
    'RedHat', 'Amazon': {
      case $::operatingsystemmajrelease {
        '6', '7': {
          $package_name = 'riemann'
          $service_name = 'riemann'
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
