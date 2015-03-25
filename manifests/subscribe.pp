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
  $async_queue_options = {
    ':core-pool-size' => '4',
    ':max-pool-size'  => '128',
    ':queue-size'     => '1000',
  },
  $stream = 'where true',
  $async_queue_name = "${::hostname}-${title}",
  $pubclass = 'default',
  $puppet_environment = $environment
) {
  $async_queue_options_string = sort(join(join_keys_to_values($async_queue_options, ' '),' '))
  @@riemann::config::fragment { "subscribe ${::clientcert} ${title}":
    content            => template('riemann/subscribe.erb'),
    section            => 'subscription',
    pubclass           => $pubclass,
    puppet_environment => $puppet_environment
  }
}
# vim: ft=puppet
