#
class { '::riemann::server':
  config_dir => '/tmp/riemann',
}

class { 'riemann::streams':
  pubclass => [ 'a', 'b', 'c' ]
}

riemann::stream { 'index everything':
  content => '(index)'
}

riemann::stream { 'compute rate by service and host':
  content => '(by [:host :service] (rate 5 (index)))'
}

# this is on the subscriber side:
# subscribes to subclass 'a'
riemann::subscribe { 'riemann internals':
  batch      => '100 1',
  queue_size => '300',
  stream     => 'where (service #"riemann%")',
  pubclass      => 'a'
}
# subscribes to subclasses 'c' and 'd'
riemann::subscribe { 'changed state':
  batch      => '100 1',
  queue_size => '300',
  stream     => 'changed :state {:init "ok"}',
  pubclass      => ['d', 'c']
}
