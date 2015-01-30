#
class {'riemann::server':
  config_dir => '/tmp/riemann'
}

riemann::server::config::listen { ['udp','tcp','ws', 'sse', 'graphite']: }
riemann::stream { '(index)': }
riemann::stream {'(by :service
    (coalesce
      (smap folds/sum
        (with :host nil
          (index)))))':
}
riemann::server::config::fragment { 'my custom fragment':
  content => '(periodically-expire 10 {:keep-keys [:host :service :tags]})\n'
}
