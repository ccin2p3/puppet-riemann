#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::config
#
# This class is called from riemann
# It makes sure riemann's configuration file is present
#
class riemann::config {
  $debug = $riemann::debug
  if $debug {
    $debug_header = ";begin ${title}"
    $debug_footer = ";end ${title}\n"
  }
  $config_dir = $::riemann::config_dir
  $config_include_dir = $::riemann::config_include_dir
  file { $config_dir:
    ensure => directory
  } ->
  file { "${config_dir}/${config_include_dir}":
    ensure => directory
  } ->
  concat { 'riemann_config':
    ensure => present,
    path   => "${config_dir}/riemann.config",
  }
  riemann::config::fragment { 'header':
    content => template('riemann/riemann.config-header.erb'),
    order   => '00'
  }
  riemann::config::fragment { 'footer':
    content => template('riemann/riemann.config-footer.erb'),
    order   => '999'
  }
  if $riemann::manage_init_defaults {
    $merged_init_config_hash = merge($::riemann::init_config_hash,$::riemann::params::init_config_hash)
    file {$::riemann::init_config_file:
      ensure  => present,
      content => template('riemann/init_config_file.erb'),
      notify  => Service[$::riemann::service_name]
    }
  }
}
# vim: ft=puppet
