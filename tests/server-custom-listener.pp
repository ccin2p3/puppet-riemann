#
class { '::riemann::server':
  config_dir => '/tmp/riemann'
}

class { 'riemann::server::config::listen':
  sse         => {
    'headers' => '{"Access-Control-Allow-Origin" "*"}'
  },
  tcp      => {
    'port' => 5555,
  },
  udp           => {
    'interface' => '0.0.0.0'
  },
  ws        => true,
}
