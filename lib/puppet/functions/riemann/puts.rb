require 'pp'
Puppet::Functions.create_function(:'riemann::puts') do
  def puts(*args)
    $stdout.puts args
  end
end
