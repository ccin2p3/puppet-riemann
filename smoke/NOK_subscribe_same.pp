class {'riemann':
    config_dir => '/tmp/riemann',
}

riemann::subscribe { 'blah':
  streams => 'foo',
  stream  => 'something'
}

riemann::subscribe { 'something':
  streams => 'foo',
}
