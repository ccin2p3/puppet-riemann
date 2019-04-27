$a = [ 1, 2, 3 ]
$b = { 'z' => 'b', 'c' => 'd' }
$r1=riemann::clj_vec($a)
$r2=riemann::clj_map($b)
riemann::puts($r1)
riemann::puts($r2)
