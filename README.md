# Puppet Module riemann

[![Build Status](https://travis-ci.org/ccin2p3/puppet-riemann.svg?branch=master)](https://travis-ci.org/ccin2p3/puppet-riemann)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What riemann affects](#what-riemann-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

This module manages the [riemann](http://riemann.io) stream processor.

## Module Description

The main features of this module are:

* Manage configuration files
* Manage service and graceful reload
* Supports using hiera for merging configuration blocks
* Implements a pubsub mechanism for orchestrating riemann downstream servers

## Setup

### What riemann affects

* Ensures Package['riemann'] is present
* Ensures Service['riemann'] is running and enabled
* Manages File['/etc/riemann/riemann.config']
* Ensures service is reloaded (using OS default method) if configuration changes

### Setup Requirements

You must ensure the riemann package is present on your package provider's repository. This module will not install packages from http://riemann.io.

If you want to use the pubsub mechanism of this module, you need to have `storeconfigs` set to `true`.

## Usage

### Main Class

```Puppet
 # Use OS defaults
include riemann
```

```Puppet
 # Override some defaults
class {'riemann':
	config_dir => '/opt/etc/riemann',
	package_name => 'myriemann',
	reload_command => 'pkill -HUP riemann'
}
```

```Puppet
 # Use hiera to pull in configuration blocks
class {'riemann':
  use_hiera => true
}
```

### Configuration blocks

```Puppet
 # surround default streams with let expression
riemann::let { 'index':
  content => {
  	'index' => '(default :ttl 300 (index))'
  }
}

 # add a stream function to default streams
riemann::stream {'00-index-everything-first':
  content => 'index'
}

 # add another one using puppet structures
riemann::stream { '10-compute total users':
  content => [
    'where', ['service','"users/users"'],
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
}
```

### Multiple streams blocks

The most straightforward way to build your riemann configuration is defining [stream](#define-riemannstream) resources. Under the hood this will autodefine a [streams](#define-riemannstreams) resource with *title* `default`. This `default` stream will be surrounded by a [let](#define-riemannlet) block which can be used to define clojure bindings.

If you want multiple [streams](#define-riemannstreams), you can do so by explicitly defining them, and assigning [stream](#define-riemannstream) resources to them. Here is an example which will generate two `(streams …)` blocks with a stream function each.

#### Puppet code

```Puppet
 # custom fragment
riemann::config::fragment {'index':
  content => '(def index (default {:ttl 30 :state "ok"} (index)))'
}

 # two streams
riemann::streams {'index it':}
riemann::streams {'tag it':}

 # one stream function per stream
riemann::stream {'index':
  streams => 'index it',
  content => 'index',
}
riemann::stream {'tag':
  streams => 'tag it',
  content => '(changed-state {:init "ok"}
                (tag "changed-state"
                  index))'
}
```

#### Resulting clojure config

```Clojure
(def index (default {:ttl 30 :state "ok"} (index)))
(let []
	(streams
		index))
(let []
	(streams
		(changed-state {:init "ok"}
      (tag "changed-state"
        index))))
```

### Publish/subscribe

Riemann nodes can *subscribe* to others which *publish* certain streams.
Special care has been given to limit subscriptions to the same puppet environment.
Here is an example that should be self explanatory. The published stream's content should be an array
of two values which will be contatenated together with the subscriber's reference in between.

#### Puppet code

##### On the publishing node

```Puppet
riemann::stream::publish {'NOK':
  content => [
    '(where (not (state "ok"))',
    ')'
  ]
}
```

##### On the subscribing node

```Puppet
riemann::subscribe {'NOK':}
```

#### Resulting clojure config

##### On the publishing node

```Clojure
(let [node0123-NOK (batch 200 1/10
                     (async-queue! :node0123-NOK
                       (forward
                         (tcp-client :host "node123"))))]
  (streams
    (where (not (state "ok"))
      node123-NOK)))
```

##### On the subscribing node


```Clojure
(let []
  (streams))
```

##### Notes

* An async queue with batching is created on the publisher
* No config is generated on the subscriber (no state)
* The subscriber can specify async-queue and batching options

## Reference

Most defined types will take as argument the name of the `streams` section to which they apply.
For the sake of simplicity, this will default to the string `default`, which is fine if you only want one `(streams …)` block in your config.

### Class riemann

This is the base class. Most parameters will use OS specific values unless overriden.

#### Parameters

* `use_hiera` boolean controlling if [hiera](#class-riemannhiera) should be used to create resources. Variable names are the same as the defined types. Defaults to `true`
* `package_name` string containing the name of the Package to install. Defaults to OS specific value (see `params.pp`)
* `service_name` string containing the name of the Service to manage. Defaults to OS specific value (see `params.pp`)
* `config_dir` string containing the path to the configuration directory. Defaults to OS specific value (see `params.pp`)
* `config_include_dir` string containing the path to the configuration directory which should be included. Defaults to OS specific value (see `params.pp`)
* `init_config_file` string containing the path to the init system's configuration for riemann. Defaults to OS specific value (see `params.pp`)
* `reload_command` string containing the command to run for reloading the riemann daemon. Defaults to OS specific value (see `params.pp`)

### Class riemann::hiera

This class is responsible for automatically creating resources for the module's provided defined types. All defined types listed in this document will be pulled in if `use_hiera` is set to `true` (default behaviour). The name convention is to use the same name for the variable as the pointed type. You can provide a prefix to the variable name.

#### Parameters

* `hiera_prefix` string containing variable prefix in hiera. Defaults to empty string.

#### Example

```YAML
riemann::hiera::hiera_prefix: mysite_
mysite_riemann::stream:
  foo:
    content: |-
      (where (service #"foo")
        index)
```

### Define riemann::streams

This type defines a `(streams … )` block which will contain stream functions. If you only need one of these, you can omit it because it will be created for you (with `$title='default'`) when defining a [stream](#define-riemannstream).

#### Parameters

* `let` array containing bindings. Defaults to `[]`
* `order` string which will let you order different streams

#### Example

```Puppet
riemann::streams {'mystream':}
riemann::streams {'myotherstream':
  let => 'index (index)',
  order => '00'
}
```

### Define riemann::let

This type will let you (no pun intended) define (same here) symbols for the surrounded `(streams …)` block. This has the same effect as the `let` parameter of [streams](#define-riemannstreams).

#### Parameters

* `content` string or array or hash. Defaults to `title`
* `streams` string referencing the surrounded streams expression

#### Examples

```Puppet
riemann::let { 'rate':
  streams => 'mystream',
  content => {
  	rate => '(rate 5 (with :service "req rate" index))'
  }
}
```

### Define riemann::stream

This type defines configuration blocks containing stream functions *i.e.* that will be contained in a `(streams …)` expression.

#### Parameters

* `content` string or structure describing the stream function. If a string is provided, it will be passed as-is. Otherwise the module will try its best at generating an s-expression. The latter feature should be considered experimental.
* `streams` string referencing the targeted [streams](#define-riemannstreams) section.

#### Examples

```Puppet
 # stream targeting 'default' stream (verbatim)
riemann::stream { 'state_changes':
  content => '(changed-state {:init "ok"} index)'
}

 # stream targeting 'mystream' (puppet style)
riemann::stream { 'rate':
  streams => 'mystream',
  content => [
    'by [:service :host]',
    [
      'coalesce', [ 'smap', 'folds/sum', [ 'with', { 'host' => 'nil' }, 'indexer' ] ] 
    ]
  ]
}
```

### Define riemann::stream::publish

This is the publisher part of this module's pubsub model.
Use this for forwarding streams to other riemann nodes.

The way this currently works is by creating a `let` binding per subscription for the publisher's targeted `(streams …)` block. The published stream consists of two halves between which the subscriber binding will be squeezed. I hope to find a better implementation (patches welcome).

#### Parameters

* `content` Array with two elements. The first element of the expression comes before the subscriber binding. The second comes after the subscriber. If no subscriber is defined in your site, the stream will basically be a noop stream (patches welcome). Defaults to something which will forward all events (the code is embarassing).
* `streams` string referencing the targeted streams section. Defaults to `default`

#### Example

```Puppet
riemann::stream::publish { 'service-foo':
  content => [ '(where (service "foo")', ')' ]
}
```

#### Note

If you want to forward all events, just use the default, *e.g.* `riemann::stream::publish {'all':}`.

### Define riemann::subscribe

This is the subscriber part of this module's pubsub model.
Use this for subscribing to other node's published streams.
In terms of the node's configuration, this will have no effect locally. The state described by this type will only have effect on the publishers.

#### Parameters

* `stream` string describing stream to subscribe to. All publishers having the equivalent [riemann::stream::publish](#define-riemannstreampublish) counterpart will forward events to us
* `streams` string describing streams corresponding to the publishing side
* `batch` string describing [batching](http://riemann.io/api/riemann.streams.html#var-batch) properties. Defaults too `'200 1'` *i.e.* send batches of events once either 200 events have accumulated or 1 second has passed.
* `async_queue_options` hash describing the options of the [async-queue](http://riemann.io/api/riemann.config.html#var-async-queue%21) which will be set up on the remote riemann instance. Defaults to `{':core-pool-size' => '4',':max-pool-size'=>'128',':queue-size'=>'1000'}`

#### Example

```Puppet
riemann::subscribe {'service-foo':
  batch => '100 1/10',
  async_queue_options = {
  	':core-pool-size' => '16',
  	':queue-size' => '10000'
  }
}
```

### Define riemann::listen

Set up listeners *e.g.* servers. Should be self-explanatory. If it isn't please complain. Not sure why I named this "listener" instead of "server".

#### Parameters

* `type` string type of server, *e.g.* [`tcp`](http://riemann.io/api/riemann.config.html#var-tcp-server), [`graphite`](http://riemann.io/api/riemann.config.html#var-graphite-server), …. Defaults to the resource's title
* `options` hash for specifying options to listener

#### Examples

```Puppet
 # TCP and UDP servers with defaults
riemann::listen { 'tcp': }
riemann::listen { 'myudp':
  type => 'udp'
}

 # websocket with custom port
riemann::listen { 'ws':
  options => {
  	'port' => '55556',
  	'host' => '"0.0.0.0"'
  }
}
```

### Class riemann::logging

Set up Riemann [logger](http://riemann.io/api/riemann.logging.html).

#### Parameters

* `options` Hash with custom options. Keys will be joined with values. Defaults to `'file' => '"${riemann::params::log_file}"'`

#### Examples

```Puppet
class {'riemann::logging':
  options => {
  	files => '[{:path "/var/log/riemann/riemann.log" :layout :json-event}]'
  }
}
```

### Define riemann::config::fragment

Defines custom riemann block. If you don't like [riemann::stream](#define-riemannstream) you can use this instead to make your own streams.

#### Parameters

* `content` string or structure (will be converted to s-expression using DWIM)
* `order` string controlling the ordering in the file

#### Examples

```Puppet
riemann::config::fragment {'george':
  content => '(periodically-expire 30)',
  order   => '03'
}
```

## Limitations

Known issues (patches welcome):

* published streams syntax is unflexible. This should be improved *e.g.* with puppet4 parser syntax
* target config file formatting is horrible. This should be improved with passing the generated config to a formatter (would require a [concat](https://forge.puppetlabs.com/puppetlabs/concat) patch)
* config reload is fine as long as config restart isn't needed. This would require doing conditional reload/restarts depending on type of change. tricky
* let blocks and published streams without subscribers can be empty: while this doesn't impair riemann, it's ugly and should be improved. Not sure this is even possible with exported resources
* the exported resources model for pubsub is quite painful to implement. Maybe use [puppetdbquery](https://forge.puppetlabs.com/dalen/puppetdbquery) or [datacat](https://forge.puppetlabs.com/richardc/datacat) in the future
* rspec coverage is poor (sorry)

## Development

Please submit your PRs on
[github](http://github.com/ccin2p3/puppet-riemann)

### Testing

```
bundle install --path vendor/bundle
bundle exec rake spec
```

### Issues

[freenode \#riemann @faxmodem](irc://freenode/riemann), [github](http://github.com/ccin2p3/puppet-riemann/issues), [gitlab](https://gitlab.in2p3.fr/cc-in2p3-puppet-service/riemann)

[//]: # vim: ft=markdown
