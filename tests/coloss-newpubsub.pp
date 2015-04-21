class {'riemann':
  config_dir => '/tmp/riemann',
}
riemann::config::fragment { 'index':
  content                => ['def', 'indexer',
    [ 'default', { 'ttl' => 30, 'state' => '"ok"' }, [ 'index' ]
    ]
  ],
  order   => '11'
}
riemann::listen { 'tcp': }
riemann::listen { 'udp': }

# on the publishing side
riemann::stream::publish { 'collectd':
  content => ['(where (tagged "collectd")',')']
}

# on (another|same) publisher
riemann::stream::publish { 'changed':
  content => [
    '(where (not (expired? event))
        (changed-state {:init "ok"}',
    # subscribers will be added here in between elements
    '))'
  ]
}

# on the subscribing side
riemann::subscribe { 'collectd': # specific batching/queueing options
  batch => '100 1/10',
  async_queue_options => {
    ':core-pool-size' => '4',
    ':max-pool-size'  => '128',
    ':queue-size'     => '1000',
  },
}
riemann::subscribe { 'changed': } # default batching/queueing options

