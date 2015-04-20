# Puppet Module riemann

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

 # Override some defaults
class {'riemann':
	config_dir => '/opt/etc/riemann',
	package_name => 'myriemann',
	reload_command => 'pkill -HUP riemann'
}

 # Use hiera to pull in configuration blocks
class {'riemann':
  use_hiera => true
}
```

### Configuration blocks

```Puppet
 # surround streams with let expression
riemann::let { 'index':
  content => {
  	'index' => '(default :ttl 300 (index))'
  }
}

 # add a stream function
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

The most straightforward way to build your riemann configuration is defining (stream)[#define-stream] resources. Under the hood this will autodefine a (streams)[#define-streams] resource with *title* `default`. This `default` stream will be surrounded by a (let)[#define-let] block which can be used to define clojure aliases.

If you need multiple (streams)[#define-streams], you can do so by explicitly defining them, and assigning (stream)[#define-stream] resources to them. Here is an example which will generate two streams blocks with a stream function each.

#### Example: Puppet code

```Puppet
riemann::config::fragment {'index':
  content => '(def index (default {:ttl 30 :state "ok"} (index)))'
}

riemann::streams {'index it':}
riemann::streams {'tag it':}

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

#### Example: Resulting clojure config

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

Riemann servers can *subscribe* to other riemann servers which *publish* certain streams.
Special care has been given to limit subscriptions to the same puppet environment.
Here is an example that should be self explanatory. The published stream's content should be an array
of two values which will be contatenated together with the subscriber's reference in between.

#### Example: Puppet code

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

#### Example: Resulting riemann config

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

As you can see, an async queue is created on the publisher, and nothing in particular on the subscriber. The subscriber can specify async-queue and batching options.

## Reference

Most defined types will take as argument the name of the `streams` section to which they apply.
For the sake of simplicity, this will default to the string `default`, which is fine if you only want one `(streams ...)` block in your config.

### Class riemann

This is the base class. Most parameters will use OS specific values unless overriden.

#### Parameters

* `use_hiera` boolean controlling if hiera should be used to create resources. Variable names are the same as the defined types. Defaults to `true`
* `package_name` string containing the name of the Package to install. Defaults to OS specific value (see `params.pp`)
* `service_name` string containing the name of the Service to manage. Defaults to OS specific value (see `params.pp`)
* `config_dir` string containing the path to the configuration directory. Defaults to OS specific value (see `params.pp`)
* `config_include_dir` string containing the path to the configuration directory which should be included. Defaults to OS specific value (see `params.pp`)
* `init_config_file` string containing the path to the init system's configuration for riemann. Defaults to OS specific value (see `params.pp`)
* `reload_command` string containing the command to run for reloading the riemann daemon. Defaults to OS specific value (see `params.pp`)

### Class riemann::hiera

This class is responsible for automatically creating resources for the module's provided defined types. All defined types listed in this document will be pulled in if `use_hiera` is set to `true` (default behaviour). The name convention in hiera is to use the same name for the variable as the pointed type. You can provide a prefix to the variable name.

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

This type defines a `(streams … )` block which will contain stream functions. If you only need one of these, you can omit it because it will be created for you (with `$title='default'`) when defining a (stream)[#define-riemann-stream].

#### Parameters

* `let` array containing alias blocks. Defaults to `[]`
* `order` string which will let you order different streams

### Define riemann::let

This type will let you (no pun intended) define (same here) symbols for the surrounded `streams` block. This has the same function as the `let` parameter of (streams)[#define-riemann-streams].

#### Parameters

* `content` string or array or hash. Defaults to `title`
* `streams` string referencing the surrounded streams expression

#### Examples

```Puppet
riemann::let { 'rate':
  content => {
  	rate => '(rate 5 (with :service "req rate" index))'
  }
}
```

### Define riemann::stream

This type defines configuration blocks containing stream functions *i.e.* that will be contained in a `(streams …)` expression.

#### Parameters

* `content` string or structure describing the stream function. If a string is provided, it will be passed as-is. Otherwise the module will try its best at generating an s-expression. The latter feature should be considered experimental.
* `streams` string referencing the targeted (streams)[#define-riemann-streams] section.

#### Examples

```Puppet
riemann::stream { 'state_changes':
  content => '(changed-state {:init "ok"} index)'
}
riemann::stream { 'rate':
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

#### Parameters

* `content` Array with two elements. The first element being the first part of the expression, before the subscriber alias. The second being the second part, after the subscriber. If no subscriber is defined in your site, the stream will basically be a noop stream.
* `streams` string referencing the streams part. Defaults to `default`

#### Example

```Puppet
riemann::stream::publish { 'service-foo':
  content => [ '(where (service "foo")', ')' ]
}
```

### Define riemann::subscribe

This is the subscriber part of this module's pubsub model.
Use this for subscribing to other node's published streams.
In terms of the node's configuration, this will have no effect locally. The state described by this type will only have effect on the publishers.

#### Parameters

* `stream` string describing stream to subscribe to. All publishers having the equivalent (riemann::stream::publish)[#define-riemann-stream-publish] counterpart will send events to us
* `streams` as usual
* `batch` string describing batch properties. See [riemann.io/api/batching]. Defaults too '200 1' *i.e.* batches of 200 events maximum or 1 second maximum.
* `async_queue_options` hash describing the options of the async-queue which will be set up on the remote riemann instance. Defaults to `{':core-pool-size' => '4',':max-pool-size'=>'128',':queue-size'=>'1000'}`

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

Set up listeners *e.g.* servers. Should be self-explanatory. If it isn't please complain on github.

#### Parameters

* `type` string type of listener, *e.g.* `tcp`, `graphite`, …. Defaults to the resource's title
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

Riemann logger

#### Parameters

* `options` Hash with custom options. See Riemann documentation

#### Examples

```Puppet
class {'riemann::logging':
  options => {
  	files => '[{:path "/var/log/riemann/riemann.log" :layout :json-event}]'
  }
}
```

### Define riemann::config::fragment

Defines custom riemann block. If you don't like (riemann::stream)[#define-riemann-stream] you can use this instead to make your own streams.

#### Parameters

* `content` string or structure
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

* published streams syntax is unflexible. This should be improved with puppet4 parser syntax
* target config file formatting is horrible. This should be improved with passing the generated config to a formatter
* config reload is fine as long as config restart isn't needed. This would need doing conditional reload/restarts depending on type of change. tricky
* let blocks and published streams without subscribers can be empty: while this doesn't impair riemann, it's ugly and should be improved. Not sure this is even possible with exported resources
* the exported resources model for pubsub is quite painful to implement. Maybe use puppetdbquery or datacat in the future

## Development

Please submit your PRs on
(github)[http://github.com/ccin2p3/puppet-riemann]

### Testing

```
bundle install --path vendor/bundle
bundle exec rake spec
```

### Issues

https://gitlab.in2p3.fr/cc-in2p3-puppet-service/riemann

[//]: # vim: ft=markdown
