#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::server::params
#
# This class is called from riemann::server
# It sets platform specific defaults
#
class riemann::server::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'riemann'
      $service_name = 'riemann'
      $config_dir = '/etc/riemann'
      $init_config_file = '/etc/default/riemann'
    }
    'RedHat', 'Amazon': {
      case $::operatingsystemmajrelease {
        '6', '7': {
          $package_name = 'riemann'
          $service_name = 'riemann'
          $config_dir = '/etc/riemann'
          $init_config_file = '/etc/sysconfig/riemann'
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
  $reload_command = "pkill -HUP -x ${service_name}"
  $config_include_dir = "conf.d"
}

# vim: ft=puppet
