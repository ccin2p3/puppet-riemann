class {'riemann':
  config_dir     => '/tmp/riemann',
  reload_command => '/bin/true',
}

riemann::listen {'tcp':
  options => { 'port' => 55555 },
}

riemann::stream::publish { 'everything':
  streams => 'default',
}

riemann::let {'index':
  content => { 'index' => '(index)' },
}

riemann::stream {'00 index':
  content => 'index',
}

riemann::subscribe { 'gimme all':
  stream  => 'everything',
  streams => 'default',
}
