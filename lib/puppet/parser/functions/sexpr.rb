#
# sexpr.rb
#

def _serel *args
  if args.length == 1
    level = 0
  elsif args.length == 2
    level = args[1]
  else
    raise(Puppet::Error, "_serel(): one or two args only")
  end
  arg = args[0]
  result = ""
  sp = ' ' * level * 2 + '  '
  case arg
  when Array
    inner = []
    arg.each do |a|
      inner.push(_serel(a,level+1))
    end
    result += "\n#{sp}(" + inner.join(' ') + ')'
  when Hash
    inner = []
    arg.each do |k,v|
      inner.push(":#{k} #{v}")
    end
    result += '{' + inner.join(' ') + '}'
  else
    result += arg.to_s
  end
  return result
end

module Puppet::Parser::Functions
  newfunction(:sexpr, :type => :rvalue, :doc => <<-EOS
This converts an array into an s-expression: a nested tree structure. For each array element, if it is a:

* String: will be passed as-is
* Array:  will be a clojure vector
* Hash:   will be a clojure map

Example:

The following puppet structure:

[ 'where', ['service','"users/users"'],
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

When passed to sexpr will yield the string:

(where
  (service "users/users")
  (with {:service "total users" :ttl 300}
    (coalesce
      (throttle 1 1
        (smap folds/sum
          (with {:host nil} index))))))
    EOS
  ) do |arguments|

    if arguments.empty?
      return []
    end

    if arguments.length == 1
      return _serel(arguments[0])
    else
      raise(Puppet::Error, "sexpr(): only one argument accepted")
    end
  end
end

# vim: set ts=2 sw=2 et :
