# redis cookbook
[![Build Status](https://travis-ci.org/szelcsanyi/chef-redis.svg?branch=master)](https://travis-ci.org/szelcsanyi/chef-redis)

## Description

Configures [Redis](http://redis.io/) via Opscode Chef

It can handle multiple instances with different configuratioins on the same machine.

Currently only one version is supported.

## Supported Platforms

* Ubuntu
* Debian

## Recipes

* `redis` - The default no-op recipe.

## Providers
* `redis_pool` - Configures redis instance

## Usage
###Provider parameters:

* `port`: listen port (default 6379)
* `bind`: listen address (default "127.0.0.1")
* `unixsocketperm`: Unix socket permission (default 755)
* `timeout`: timeout interval (default 0, no timeout)
* `tcp_keepalive`: tcp keepalive interval (default 0, no keepalive)
* `loglevel`: log level (default "notice")
* `databases`: number of databases (default 16)
* `datadir`: directory for storing data (default /usr/lib/redis-poolname)
* `maxmemory`: maximum memory to use (default "1gb")
* `maxmemory_policy`: eviction policy (default "volatile-lru")
* `maxmemory_samples`: memory samples (default 3)
* `slaveof`: master server ip address (default no master)
* `slave_read_only`: is slave read only (default "yes")
* `snapshotting`: snapshotting (default true)


#### A redis instance with default settings:
```ruby
redis_pool "basic_example"
```

#### A redis instance with custom parameters:
```ruby
redis_pool "extended_example" do
    port "6390"
    bind "0.0.0.0"
    databases 2
    datadir "/opt/custom_redis"
end
```

## TODO
Implement multiversion support.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

* Freely distributable and licensed under the [MIT license](http://szelcsanyi.mit-license.org/2014/license.html).
* Copyright (c) 2014 Gabor Szelcsanyi

[![image](https://ga-beacon.appspot.com/UA-56493884-1/chef-redis/README.md)](https://github.com/szelcsanyi/chef-redis)

