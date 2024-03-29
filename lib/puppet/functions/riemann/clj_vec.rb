# frozen_string_literal: true

# This converts an array into a string containing a serialized clojure vector.
#
# Example:
#
# The following puppet structure:
#
# ['service','"users/users"'],
#
# Will yield the string:
#
# (service "users/users")
#
# Arguments: $array
Puppet::Functions.create_function(:'riemann::clj_vec') do
  def clj_vec(*arguments)
    return [] if arguments.empty?

    raise(Puppet::Error, 'clj_vec(): only one argument accepted') unless arguments.length == 1
    raise(Puppet::Error, 'clj_vec(): argument must be an array') unless arguments[0].is_a?(Array)

    "(#{arguments[0].join(' ')})"
  end
end

# vim: set ts=2 sw=2 et :
