#
class riemann::server::config::listen (
  $sse = false,
  $tcp = true,
  $udp = true,
  $ws  = true
) {
  case $sse {
    true: {
      riemann::server::config::fragment { 'riemann_server_config_sse':
        content => '(sse-server)\n'
      }
    }
    false: {}
    default: {
      if is_hash {
        $sse_content = join(
          join_keys_to_values($sse,' '),
          ' :'
        )
        riemann::server::config::fragment { 'riemann_server_config_sse':
          content    => "(sse-server :${sse_content})\n"
        }
      } else {
        fail('param sse must be bool or hash')
      }
    }
  }
  case $tcp {
    true: {
      riemann::server::config::fragment { 'riemann_server_config_tcp':
        content => '(tcp-server)\n'
      }
    }
    false: {}
    default: {
      if is_hash {
        $tcp_content = join(
          join_keys_to_values($tcp,' '),
          ' :'
        )
        riemann::server::config::fragment { 'riemann_server_config_tcp':
          content    => "(tcp-server :${tcp_content})\n"
        }
      } else {
        fail('param tcp must be bool or hash')
      }
    }
  }
  case $udp {
    true: {
      riemann::server::config::fragment { 'riemann_server_config_udp':
        content => '(udp-server)\n'
      }
    }
    false: {}
    default: {
      if is_hash {
        $udp_content = join(
          join_keys_to_values($udp,' '),
          ' :'
        )
        riemann::server::config::fragment { 'riemann_server_config_udp':
          content    => "(udp-server :${udp_content})\n"
        }
      } else {
        fail('param udp must be bool or hash')
      }
    }
  }
  case $ws {
    true: {
      riemann::server::config::fragment { 'riemann_server_config_ws':
        content => '(ws-server)\n'
      }
    }
    false: {}
    default: {
      if is_hash {
        $ws_content = join(
          join_keys_to_values($ws,' '),
          ' :'
        )
        riemann::server::config::fragment { 'riemann_server_config_ws':
          content    => "(ws-server :${ws_content})\n"
        }
      } else {
        fail('param ws must be bool or hash')
      }
    }
  }
}
