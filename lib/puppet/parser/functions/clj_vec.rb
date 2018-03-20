#
# clj_vec.rb
#

module Puppet::Parser::Functions
  newfunction(:clj_vec, type: :rvalue, doc: <<-EOS
This converts an array into a string containing a serialized clojure vector.

Example:

The following puppet structure:

['service','"users/users"'],

Will yield the string:

(service "users/users")

Arguments: $array
    EOS
             ) do |arguments|

    return [] if arguments.empty?

    if arguments.length == 1
      unless arguments[0].is_a?(Array)
        raise(Puppet::Error, 'clj_vec(): argument must be an array')
      end
    else
      raise(Puppet::Error, 'clj_vec(): only one argument accepted')
    end

    result = '(' + arguments[0].join(' ') + ')'
    return result
  end
end

# vim: set ts=2 sw=2 et :
