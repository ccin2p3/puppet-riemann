# This converts a nested structure into a string containing an s-expression.
# It will serialize each element it encounters recursively:
#
# * String: will be passed as-is
# * Array:  will be a clojure vector
# * Hash:   will be a clojure map
#
# Example:
#
# The following puppet structure:
#
# [ 'where', ['service','"users/users"'],
#   ['with', {'service' => '"total users"', 'ttl' => 300},
#     [ 'coalesce',
#       [ 'throttle', 1, 1,
#         [ 'smap', 'folds/sum',
#           [ 'with', { 'host' => 'nil' }, 'index' ]
#         ]
#       ]
#     ]
#   ]
# ]
#
# When passed to sexpr will yield the string:
#
# (where
#   (service "users/users")
#   (with {:service "total users" :ttl 300}
#     (coalesce
#       (throttle 1 1
#         (smap folds/sum
#           (with {:host nil} index))))))
#
# Arguments: $object $indent_level
Puppet::Functions.create_function(:sexpr) do
  def _serel(arg, indent, level = 0)
    result = ''
    sp = ' ' * level * 2 + '  ' * indent
    case arg
    when Array
      inner = []
      arg.each do |a|
        inner.push(_serel(a, indent, level + 1))
      end
      result += "\n" if level > 0
      result += "#{sp}(" + inner.join(' ') + ')'
    when Hash
      inner = []
      arg.sort.each do |k, v|
        inner.push(":#{k} #{v}")
      end
      result += '{' + inner.join(' ') + '}'
    else
      result += arg.to_s
    end
    result
  end

  def sexpr(*arguments)
    return [] if arguments.empty?

    indent = 0
    if arguments.length == 2
      indent = arguments[1].to_i
    elsif arguments.length == 1
      indent = 0
    else
      raise(Puppet::Error, 'sexpr(): only one argument accepted')
    end
    return '  ' * indent + arguments[0] + "\n" if arguments[0].is_a?(String)
    return _serel(arguments[0], indent) + "\n"
  end
end

# vim: set ts=2 sw=2 et :
