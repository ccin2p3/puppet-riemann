class {'riemann':
  config_dir     => '/tmp/riemann',
  reload_command => '/bin/true',
}

include 'riemann::logging'

riemann::streams {'foo':
  let     => { 'index' => '(index)' },
}

riemann::let { 'aggregate':
  streams => 'foo',
  content => {
    'aggregate' => '(rate 5 (with :service "req rate" index))',
  },
}
riemann::let { 'fraction':
  streams => 'foo',
  content => ['fraction', 'true'],
}

riemann::stream { '00-foo':
  content => '(where (service "foo") index)',
  streams => 'foo',
}

riemann::stream { '10-changed':
  content => ['changed-state', 'index'],
  streams => 'foo',
}

riemann::stream::publish { 'something':
  content => ['(where (tagged "something")', ')'],
  streams => 'foo',
}

riemann::subscribe { 'blah':
  streams => 'foo',
  stream  => 'something',
}
