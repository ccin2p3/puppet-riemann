class {'riemann':
  config_dir     => '/tmp/riemann',
  debug          => false,
  reload_command => '/bin/true',
}
riemann::streams { 'default':
  header => '(streams (not (expired? event))',
}

riemann::stream { 'rate':
  content => [ 'by [:service :host]',
    [
      'coalesce', [ 'smap', 'folds/sum', [ 'with', { 'host' => 'nil' }, 'indexer' ]]
    ]
  ],
}
