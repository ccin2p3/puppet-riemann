class {'riemann':
  config_dir => '/tmp/riemann',
  reload_command => '/bin/true',
  debug     => false
}
riemann::config::fragment { 'reaper':
  content => ['periodically-expire', 30],
  order   => '03'
}
riemann::config::fragment { 'index':
  content                => ['def', 'indexer',
    [ 'default', { 'ttl' => 30, 'state' => '"ok"' }, [ 'index' ]
    ]
  ],
  order   => '11'
}
riemann::listen { 'tcp':
  options  => {
    'port' => 5555,
    'host' => '"0.0.0.0"'
  }
}
riemann::listen { 'udp':
  options  => {
    'port' => 5555,
    'host' => '"0.0.0.0"'
  }
}


