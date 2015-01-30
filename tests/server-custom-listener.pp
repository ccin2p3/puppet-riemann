#
class { '::riemann': debug => true}
class { '::riemann::server':
  config_dir => '/tmp/riemann'
}

riemann::server::config::listen { 'sse':
  options => {
    'headers' => '{"Access-Control-Allow-Origin" "*"}'
  }
}
riemann::server::config::listen { 'tcp localhost':
  type    => 'tcp',
  options => {
    'port' => '55555',
    'host' => '127.0.0.1'
  }
}
riemann::server::config::listen { 'tcp *':
  type    => 'tcp',
  options => {
    port    => 5555,
    host    => '0.0.0.0'
  }
}
riemann::server::config::listen { 'udp': }
riemann::server::config::listen { 'ws': }

