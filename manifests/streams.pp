#
define riemann::streams (
  $publish = true,
  $pubclass = ['default'],
)
{
  validate_bool($publish)
  validate_array($pubclass)
  if $riemann::debug {
    $debug_header = ";begin ${title}\n"
    $debug_footer = ";end ${title}\n"
  }
  $header_content = "${debug_header}(streams\n"
  $footer_content = "${debug_footer})\n"
  # header
  riemann::server::config::fragment { "streams ${title} header":
    target  => 'riemann_server_config',
    content => $header_content,
    order   => "20-${title}-00",
  }
  # collect stream
  Riemann::Server::Config::Fragment <| section == "streams ${title}" |> {
    target => 'riemann_server_config',
    order  => "20-${title}-10",
  }
  # publish to subscribers
  if $publish {
    riemann::stream::publish { $pubclass:
      streams  => $title,
    }
  }
  # footer
  riemann::server::config::fragment { "streams ${title} footer":
    target  => 'riemann_server_config',
    content => $footer_content,
    order   => "20-${title}-99",
  }
}
