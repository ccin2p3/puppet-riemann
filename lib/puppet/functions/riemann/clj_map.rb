# This converts a hash into a string containing a serialized clojure map.
#
# Example:
#
# The following puppet structure:
#
# {'foo' => 9}
#
# Will yield the string:
#
# {:foo 9}
#
# Arguments: $hash
Puppet::Functions.create_function(:'riemann::clj_map') do
  def clj_map(*arguments)
    return [] if arguments.empty?

    if arguments.length == 1
      unless arguments[0].is_a?(Hash)
        raise(Puppet::Error, 'clj_map(): argument must be a hash')
      end
    else
      raise(Puppet::Error, 'clj_map(): only one argument accepted')
    end

    inner = []
    arguments[0].sort.each do |k, v|
      inner.push(":#{k} #{v}")
    end
    result = '{' + inner.join(' ') + ')'
    return result
  end
end

# vim: set ts=2 sw=2 et :
