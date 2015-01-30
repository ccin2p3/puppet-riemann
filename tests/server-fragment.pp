#
class { '::riemann':
  debug      => true
}
class { '::riemann::server':
  config_dir => '/tmp/riemann',
}

riemann::streams { 'top stream':
  publish => true
}
riemann::streams { 'another top stream':
  publish => true
}

riemann::stream { 'index everything':
  streams => 'top stream',
  content => '(index)'
}

riemann::stream { 'compute rate by service and host':
  streams => 'top stream',
  content => '(by [:host :service] (rate 5 (index)))'
}

riemann::stream { 'do nothing':
  streams => 'another top stream',
  content => 'true'
}

# lookup config in hiera
riemann::stream { 'aggregate':
  streams => 'another top stream',
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
