#
# Class: riemann::streams
#
# this class will call (streams ...) in a riemann config
# and construct its contents using riemann::stream defines
#
define riemann::streams (
  $streams = $title,
  $let = [],
  $order = "50-${title}"
)
{
  include riemann
  # let
  riemann::config::fragment { "let ${streams} header":
    content => '(let [',
    order   => "${order}-00"
  }
  # let items given as params
  if (is_array($let)) {
    $let_body = join($let,' ')
  } elsif (is_hash($let)) {
    $let_body = join(sort(join_keys_to_values($let,' ')),' ')
  } elsif (is_string($let)) {
    $let_body = $let
  } else {
    fail("streams: 'let' must be array, hash or string")
  }
  riemann::config::fragment { "let ${streams} body":
    content => "      ${let_body}",
    order   => "${order}-10"
  }
  # collect virtual and exported let items from riemann::let
  Riemann::Config::Fragment <| section == "let streams ${streams}" and subscriber == 'local' |> {
    order   => "${order}-12"
  }
  riemann::config::fragment { "let ${streams} body end":
    content => ']',
    order   => "${order}-15"
  }
  riemann::config::fragment { "streams ${streams} header":
    content => '(streams',
    order   => "${order}-20"
  }
  # collect stream functions from riemann::stream
  Riemann::Config::Fragment <| section == "streams ${streams}" and subscriber == 'local' |> {
    order   => "${order}-25"
  }
  riemann::config::fragment { "streams ${streams} footer":
    content => ')',
    order   => "${order}-28"
  }
  riemann::config::fragment { "let ${streams} footer":
    content => ')',
    order   => "${order}-99"
  }
}
