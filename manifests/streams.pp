#
# Class: riemann::streams
#
# this class will call (streams ...) in a riemann config
# and construct its contents using riemann::stream defines
#
define riemann::streams (
  Variant[Array[String[1]], Hash[String[1], String[1]], String[1]] $let = [],
  String[1] $order = "50-${title}",
  String[1] $header = '(streams',
  String[1] $footer = ')',
)
{
  include riemann
  # let
  riemann::config::fragment { "let ${title} header":
    content => '(let [',
    order   => "${order}-00",
  }
  # let items given as params
  $let_body = $let ? {
    Array   => join($let,' '),
    Hash    => join(sort(join_keys_to_values($let,' ')),' '),
    default => $let,
  }
  riemann::config::fragment { "let ${title} body":
    content => "      ${let_body}",
    order   => "${order}-10",
  }
  riemann::config::fragment { "let ${title} clientcert alias":
    content => "      our-host \"${facts['clientcert']}\"",
    order   => "${order}-11",
  }
  # collect virtual and exported let items from riemann::let
  Riemann::Config::Fragment <| section == "let streams ${title}" and subscriber == 'local' |> {
    order   => "${order}-12"
  }
  riemann::config::fragment { "let ${title} body end":
    content => ']',
    order   => "${order}-15",
  }
  riemann::config::fragment { "streams ${title} header":
    content => $header,
    order   => "${order}-20",
  }
  # collect stream functions from riemann::stream
  Riemann::Config::Fragment <| section == "streams ${title}" and subscriber == 'local' |> {
    order   => "${order}-25"
  }
  riemann::config::fragment { "streams ${title} footer":
    content => $footer,
    order   => "${order}-28",
  }
  riemann::config::fragment { "let ${title} footer":
    content => ')',
    order   => "${order}-99",
  }
}
