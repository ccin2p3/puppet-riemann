#
class { 'riemann':
  config_dir => '/tmp/riemann',
  debug      => true
}

include riemann::logging
riemann::listen { 'tcp': }
riemann::listen { 'udp': }
riemann::listen { 'ws': }
riemann::listen { 'sse':
  options     => {
    'headers' => '{"Access-Control-Allow-Origin" "*"}'
  }
}
# string style
riemann::stream { 'index all events with default ttl':
  content => 'default :ttl 300 (index)'
}

# tree style
riemann::stream { 'compute total users':
  content => [
    'where', ['service','"users/users"'],
      ['with', {'service' => '"total users"', 'ttl' => 300},
        [ 'coalesce',
          [ 'throttle', 1, 1,
            [ 'smap', 'folds/sum',
              [ 'with', { 'host' => 'nil' }, 'index' ]
            ]
          ]
        ]
      ]
  ]
}
# hash style
riemann::stream { 'out of ideas for title':
  content  => [
    'where', [ 'service', '#"^riemann"' ],
      [ 'with',
        {
          'service' => '"plop"',
          'ttl'     => 100,
        }
      ]
  ]
}
#
# forward a stream (pubsub model)
#

# on the sender
class { 'riemann::streams':
  publish  => true,
  pubclass => ['collectd', 'changed-state', 'riemann']
}

# on the receiver
riemann::subscribe { 'collectd':
  queue_size => '1000',
  stream     => 'tagged "collectd"',
  pubclass   => 'collectd'
}
riemann::subscribe { 'subscribe to state changes':
  batch    => '100 1',
  stream   => 'changed-state {:init "ok"}',
  pubclass => 'riemann',
}

riemann::subscribe { 'riemann internals':
  batch      => '100 1',
  queue_size => '300',
  stream     => 'where (service #"riemann%")',
  pubclass   => 'a'
}

