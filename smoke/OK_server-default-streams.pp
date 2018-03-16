#
class { '::riemann':
  config_dir => '/tmp/riemann',
  reload_command => '/bin/true',
}

riemann::stream { 'index everything':
  content => '(index)'
}

riemann::stream { 'compute rate by service and host':
  content => '(by [:host :service] (rate 5 (index)))'
}

# this is on the subscriber side:
riemann::subscribe { 'riemann internals':
  batch      => '100 1',
  stream     => 'service~riemann'
}
riemann::subscribe { 'changed state':
  stream     => 'changed-state',
}
