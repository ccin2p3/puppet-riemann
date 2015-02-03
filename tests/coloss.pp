class {'riemann':
  config_dir => '/tmp/riemann',
  debug      => false
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

riemann::stream { 'index everything':
  content => 'indexer'
}

riemann::stream { 'rate':
  content => [ 'by [:service :host]',
    [
      'coalesce', [ 'smap', 'folds/sum', [ 'with', { 'host' => 'nil' }, 'indexer' ] ]
    ]
  ]
}

riemann::subscribe { 'riemann_internals':
  batch      => '100 1',
  queue_size => '100',
  stream     => 'where (service #"^riemann")',
  pubclass   => 'riemann'
}
riemann::subscribe { 'collectd_users':
  batch      => '100 1',
  queue_size => '100',
  stream     => 'where (and (tagged "collectd") (service "users/users"))',
  pubclass   => 'collectd'
}

class {'riemann::streams':
  pubclass => ['collectd','syslog','riemann']
}

