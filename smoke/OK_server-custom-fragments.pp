#
class {'riemann':
  config_dir     => '/tmp/riemann',
  reload_command => '/bin/true',
}

riemann::listen { ['udp','tcp','ws', 'sse', 'graphite']: }
riemann::stream { '(index)': }
riemann::stream {'(by :service
    (coalesce
      (smap folds/sum
        (with :host nil
          (index)))))':
}
riemann::config::fragment { 'my custom fragment':
  content => '(periodically-expire 10 {:keep-keys [:host :service :tags]})',
}
include riemann::logging
