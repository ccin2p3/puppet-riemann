require 'pp'
module Puppet::Parser::Functions
  newfunction(:puts) do |args|
    puts args
  end
end

