#
define riemann::hiera::create_resources {
  $rsname = "riemann::${title}"
  $varname = "${riemann::hiera::prefix}${rsname}"
  create_resources (
    $rsname,
    hiera_hash(
      $varname,
      {}
    )
  )
}
