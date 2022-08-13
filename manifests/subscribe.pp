#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Define riemann::subscribe
#
# This class type implements a subscription to a riemann instance
# If included, the host will be sent events from the hosts
# implementing riemann::publish using forward
# see http://riemann.io/api/riemann.streams.html#var-forward
#
# Parameters:
#
# batch: see http://riemann.io/api/riemann.streams.html#var-batch
# queue_size: async-queue size see http://riemann.io/api/riemann.config.html#var-async-queue.21
# async_queue_name: the name of the async queue
# where: the clojure code string used in the (where ...) clause in the
#        publisher's riemann config. Example: `(service "my service")`
#        defaults to `true` which means all events will be forwarded
# 
define riemann::subscribe (
  $batch = '200 1',
  $throttle = '1 10',
  $exception_stream = sprintf('(throttle 1 10 (with {:host our-host :service "%s-%s" :state "warning"} (adjust [:event #(count %%)] #(info %%))))', $facts['networking']['hostname'], regsubst($title,' ','_')),
  $async_queue_options = {
    ':core-pool-size' => '4',
    ':max-pool-size'  => '128',
    ':queue-size'     => '1000',
  },
  $stream = $title,
  $streams = 'default',
  $pubsub_var = $riemann::pubsub_var
) {
  $_sanitized_title = regsubst($title,' ','_')
  $async_queue_name = "${facts['facts['networking']['hostname']']}-${_sanitized_title}"
  $async_queue_options_string = join(sort(join_keys_to_values($async_queue_options, ' ')),' ')
  # 'let' statement fragment
  @@riemann::config::fragment { "let ${streams} publish ${async_queue_name}":
    content    => template('riemann/subscribe-let.erb'),
    section    => "let streams ${streams} ${stream}",
    subscriber => $trusted['clientcert'],
    pubsub_var => getvar($pubsub_var),
  }
  # 'stream' statement
  @@riemann::config::fragment { "stream ${streams} publish ${stream} part2 ${trusted['clientcert']}":
    content    => template('riemann/subscribe-stream.erb'),
    section    => "streams ${streams} ${stream}",
    subscriber => $trusted['clientcert'],
    pubsub_var => getvar($pubsub_var),
  }
}
# vim: ft=puppet
