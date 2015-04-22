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
puts(sexpr($d))
puts(sexpr($c))
puts(sexpr($b))
puts(sexpr($a))

