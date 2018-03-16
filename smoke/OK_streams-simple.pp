class {'riemann':
    config_dir => '/tmp/riemann',
    reload_command => '/bin/true',
}

riemann::stream::publish { 'everything': }

riemann::subscribe { 'gimme all':
  stream => 'everything'
}

