#

class riemann::hiera {
  riemann::hiera::create_resources {
    ['config::fragment','listen','let','streams','stream','stream::publish','subscribe']:
  }
}
  
define riemann::hiera::create_resources {
  $rsname = "riemann::${title}"
  create_resources (
    $rsname,
    hiera_hash(
      $rsname,
      {}
    )
  )
}
