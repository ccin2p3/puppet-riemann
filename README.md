# Puppet Module riemann
#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with riemann](#setup)
    * [What riemann affects](#what-riemann-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with riemann](#beginning-with-riemann)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This is a *technology` class, as opposed to a *site* class.
A one-maybe-two sentence summary of what the module does/what problem it solves. This is your 30 second elevator pitch for your module. Consider including OS/Puppet version it works with.       

## Module Description

If applicable, this section should have a brief description of the technology the module integrates with and what that integration enables. This section should answer the questions: "What does this module *do*?" and "Why would I use it?"

If your module has a range of functionality (installation, configuration, management, etc.) this is the time to mention it.

## Setup

### What riemann affects

* A list of files, packages, services, or operations that the module will alter, impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form. 

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled, etc.), mention it here. 

### Beginning with riemann

The very basic steps needed for a user to get the module up and running. 

If your most recent release breaks compatibility or requires particular steps for upgrading, you may wish to include an additional section here: Upgrading (For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here. 

## Reference

Here, list the classes, types, providers, facts, etc contained in your module. This section should include all of the under-the-hood workings of your module so people know what the module is touching on their system but don't need to mess with things. (We are working on automating this section!)

### Class riemann

#### Parameters

* `service_name` string containing the name of the Package to install. Defaults to OS specific value (see `params.pp`)
* `package_name` string containing the name of the Service to manage. Defaults to OS specific value (see `params.pp`)

### Class riemann::foo

#### Parameters

* `package_name` string or array containing list of packages to install. Defaults to OS specific value (see `params.pp`)
* `service` string or array containing list of services to run. Defaults to OS specific value (see `params.pp`)

### Define riemann::mytype

#### Parameters

* `my_param` string

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.

### Testing

```
bundle install --path vendor/bundle
bundle exec rake spec
```

### Issues

https://gitlab.in2p3.fr/cc-in2p3-puppet-service/riemann


## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You may also add any additional sections you feel are necessary or important to include here. Please use the `## ` header. 

[//]: # vim: ft=markdown