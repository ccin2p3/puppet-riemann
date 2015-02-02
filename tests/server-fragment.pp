#
class { '::riemann':
  debug      => true
}
class { '::riemann::server':
  config_dir => '/tmp/riemann',
}

class { 'riemann::streams':
  publish => true
}

riemann::stream { 'index everything':
  content => '(index)'
}

riemann::stream { 'compute rate by service and host':
  content => '(by [:host :service] (rate 5 (index)))'
}

riemann::stream { 'do nothing':
  content => 'true'
}

# lookup config in hiera
riemann::stream { 'aggregate':
  content => hiera('riemann::stream::aggr','true')
}

# this is on the subscriber side:
riemann::subscribe { 'riemann internals':
  batch      => '100 1',
  queue_size => '300',
  stream     => 'where (service #"riemann%")'
}
riemann::subscribe { 'changed state':
  batch      => '100 1',
  queue_size => '300',
  stream     => 'changed :state {:init "ok"}',
}