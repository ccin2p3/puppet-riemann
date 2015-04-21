class {'riemann':
    config_dir => '/tmp/riemann',
}

riemann::stream::publish { 'everything': }

riemann::subscribe { 'gimme all':
  stream => 'everything'
}

