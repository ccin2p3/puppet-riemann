class {'riemann':
  config_dir     => '/tmp/riemann',
  reload_command => '/bin/true',
}

riemann::subscribe { 'blah':
  streams => 'foo',
  stream  => 'something',
}

riemann::subscribe { 'something':
  streams => 'foo',
}
