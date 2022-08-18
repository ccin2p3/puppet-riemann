#

class { 'riemann':
  config_dir     => '/tmp/riemann',
  reload_command => '/bin/true',
  validate_cmd   => '/bin/false',
}
