#
class { '::riemann':
  config_dir => '/tmp/riemann'
}

riemann::listen { 'sse':
  options => {
    'headers' => '{"Access-Control-Allow-Origin" "*"}'
  }
}
riemann::listen { 'tcp localhost':
  type    => 'tcp',
  options => {
    'port' => '55555',
    'host' => '127.0.0.1'
  }
}
riemann::listen { 'tcp *':
  type    => 'tcp',
  options => {
    port    => 5555,
    host    => '0.0.0.0'
  }
}
riemann::listen { 'udp': }
riemann::listen { 'ws': }

