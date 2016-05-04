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
      $config_dir = '/etc/riemann'
      $init_config_file = '/etc/default/riemann'
      $reload_command = "/usr/sbin/service ${service_name} reload"
    }
    'RedHat', 'Amazon': {
      $package_name = 'riemann'
      $service_name = 'riemann'
      $config_dir = '/etc/riemann'
      $init_config_file = '/etc/sysconfig/riemann'
      case $::operatingsystem {
        'Amazon': {
          $reload_command = "/sbin/service ${service_name} reload"
        }
        default: {
          case $::operatingsystemmajrelease {
            '6': {
              $reload_command = "/sbin/service ${service_name} reload"
            }
            '7': {
              $reload_command = "/usr/bin/systemctl ${service_name} reload"
            }
            default: {
              fail("operatingsystemmajrelease `${::operatingsystemmajrelease}` not supported")
            }
          }
        }
      }
    }
    default: {
      fail("osfamily `${::osfamily}` not supported")
    }
  }
  $config_include_dir = 'conf.d'
  $init_config_hash = {}
  $log_file = '/var/log/riemann/riemann.log'
}

# vim: ft=puppet
