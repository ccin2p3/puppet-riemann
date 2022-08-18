#
class {'riemann':
  config_dir     => '/tmp/riemann',
  reload_command => '/bin/true',
}

riemann::config::fragment {'index':
  content => '(def index (default {:ttl 30 :state "ok"} (index)))',
}

riemann::streams {'index it': }
riemann::streams {'tag it': }

riemann::stream {'index':
  streams => 'index it',
  content => 'index',
}
riemann::stream {'tag':
  streams => 'tag it',
  content => '(changed-state {:init "ok"}
                (tag "changed-state"
                  index))',
}

