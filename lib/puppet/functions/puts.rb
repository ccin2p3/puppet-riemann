require 'pp'
Puppet::Functions.create_function(:puts) do
  def puts(*args)
    $stdout.puts args
  end
end
