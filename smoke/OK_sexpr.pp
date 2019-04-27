$a = [ 'where', ['service','"users/users"'],
       ['with', {'service' => '"total users"', 'ttl' => 300},
         [ 'coalesce',
           [ 'throttle', 1, 1,
             [ 'smap', 'folds/sum',
               [ 'with', { 'host' => 'nil' }, 'index' ]
             ]
           ]
         ]
       ]
     ]

$b = [ 'a','b','c' ]
$c = 'foo'
$d = { 'foo' => 'bar' }
riemann::puts(riemann::sexpr($d))
riemann::puts(riemann::sexpr($c))
riemann::puts(riemann::sexpr($b))
riemann::puts(riemann::sexpr($a))

