#
class { 'riemann':
  config_dir     => '/tmp/riemann',
  reload_command => '/bin/true',
}

include riemann::logging
riemann::listen { 'tcp': }
riemann::listen { 'udp': }
riemann::listen { 'ws': }
riemann::listen { 'sse':
  options     => {
    'headers' => '{"Access-Control-Allow-Origin" "*"}',
  },
}

# custom config fragment
riemann::config::fragment { 'this is just a pass-through':
  content => "; maybe a comment\n;and another",
  order   => '00',
}

# custom config s-expression
riemann::config::fragment { 'plop':
  content => [
    'def', 'hostname',
    [ '.getHostName',
      ['java.net.InetAddress/getLocalHost']
    ]
  ],
  order   => '01',
}

# string style
riemann::stream { 'index all events with default ttl':
  content => '(default :ttl 300 (index))',
}

# tree style
riemann::stream { 'compute total users':
  content => [
    'where', ['service','"users/users"'],
    ['with', {'service' => '"total users"', 'ttl' => 300 },
      [ 'coalesce',
        [ 'throttle', 1, 1,
          [ 'smap', 'folds/sum',
            [ 'with', { 'host' => 'nil' }, 'index' ]
          ]
        ]
      ]
    ]
  ],
}
# hash style
riemann::stream { 'out of ideas for title':
  content  => [
    'where', [ 'service', '#"^riemann"' ],
    [ 'with',
      {
        'service' => '"plop"',
        'ttl'     => 100,
      },
    ]
  ],
}
#
# forward a stream (pubsub model)
#

# on the sender
riemann::stream::publish { 'everything': }

# on the receiver
riemann::subscribe { 'collectd': }
riemann::subscribe { 'subscribe to state changes':
  batch  => '100 1',
  stream => 'other',
}

riemann::subscribe { 'riemann internals':
  batch  => '100 1',
  stream => 'everything',
}
