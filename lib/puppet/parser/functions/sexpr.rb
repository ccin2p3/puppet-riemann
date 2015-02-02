#
# sexpr.rb
#

def _serel *args
  if args.length == 2
    level = 0
  elsif args.length == 3
    level = args[2]
  else
    raise(Puppet::Error, "_serel(): one or two args only")
  end
  arg = args[0]
  indent = args[1]
  result = ""
  sp = ' ' * level * 2 + '  ' * indent
  case arg
  when Array
    inner = []
    arg.each do |a|
      inner.push(_serel(a,indent,level+1))
    end
    result += "\n#{sp}(" + inner.join(' ') + ')'
  when Hash
    inner = []
    arg.sort.each do |k,v|
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
This converts a nested structure into a string containing an s-expression.
It will serialize each element it encounters recursively:

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

Arguments: $object $indent_level
    EOS
  ) do |arguments|

    if arguments.empty?
      return []
    end

    indent = 0
    if arguments.length == 2
      indent = arguments[1].to_i
    elsif arguments.length == 1
      indent = 0
    else
      raise(Puppet::Error, "sexpr(): only one argument accepted")
    end
    return _serel(arguments[0],indent) # + "\n"
  end
end

# vim: set ts=2 sw=2 et :
