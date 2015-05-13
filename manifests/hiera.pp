#
class riemann::hiera (
  $prefix = ''
)
  {
  riemann::hiera::create_resources {
    ['config::fragment','listen','let','streams','stream','stream::publish','subscribe']:
  }
}

