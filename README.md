# L7-redis cookbook
[![Build Status](https://travis-ci.org/szelcsanyi/chef-redis.svg?branch=master)](https://travis-ci.org/szelcsanyi/chef-redis)
[![security](https://hakiri.io/github/szelcsanyi/chef-redis/master.svg)](https://hakiri.io/github/szelcsanyi/chef-redis/master)
[![Cookbook Version](https://img.shields.io/cookbook/v/L7-redis.svg?style=flat)](https://supermarket.chef.io/cookbooks/L7-redis)

## Description

Configures [Redis](http://redis.io/) via Opscode Chef

It can handle multiple instances with different configurations on the same machine.

Currently only one redis version is supported.

## Supported Platforms

* Ubuntu 12.04+
* Debian 7.0+

## Recipes

* `L7-redis` - The default no-op recipe.

## Providers
* `L7_redis_pool` - Configures redis instance

## Usage
###Provider parameters:

* `port`: listen port (default 6379)
* `bind`: listen address (default "127.0.0.1")
* `unixsocketperm`: Unix socket permission (default 755)
* `timeout`: timeout interval (default 0, no timeout)
* `tcp_keepalive`: tcp keepalive interval (default 0, no keepalive)
* `loglevel`: log level (default "notice")
* `databases`: number of databases (default 16)
* `datadir`: directory for storing data (default "/usr/lib/redis-poolname")
* `maxmemory`: maximum memory to use (default "1gb")
* `maxmemory_policy`: eviction policy (default "volatile-lru")
* `maxmemory_samples`: memory samples (default 3)
* `slaveof`: master server ip address and port (default "no master")
* `slave_read_only`: is slave read only? (default "yes")
* `masterauth`: password for master server
* `snapshotting`: snapshotting (default true)
* `requirepass`: authentication password (default nil)
* `snapshot_rules`: snapshot rules (default [ "900 1", "300 10", "60 10000" ])
* `stop_writes_on_bgsave_error`: stop writes on error (default "yes")
* `appendonly`: persistence type (default "yes")
* `appendfsync`: persistence flush (default "everysec")
* `no_appendfsync_on_rewrite`: (default "no")
* `auto_aof_rewrite_percentage`: (default 100)
* `auto_aof_rewrite_min_size`: (default "64mb")
* `aof_rewrite_incremental_fsync`: (default: "yes")
* `config`: configuration hash with parameters like above

#### A redis instance with default settings:
```ruby
L7_redis_pool 'basic_example'
```

#### A redis instance with custom parameters:
```ruby
L7_redis_pool 'extended_example' do
    port '6390'
    bind '0.0.0.0'
    databases 2
    datadir '/opt/custom_redis'
end
```

#### A redis instance with default attributes overridden:
```ruby
node.override['L7-redis']['config']['databases'] = 16
node.override['L7-redis']['config']['repl-backlog-size'] = '256mb'

L7_redis_pool 'redis6379' do
  config ({
    'port' => '6379',
    'bind' => '0.0.0.0',
    'maxmemory' => '100mb'
  })
end

L7_redis_pool 'redis6380' do
  config ({
    'port' => '6380',
    'bind' => '127.0.0.1',
    'maxmemory' => '10mb',
    'slaveof' => '127.0.0.1 6379'
  })
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

* Freely distributable and licensed under the [MIT license](http://szelcsanyi.mit-license.org/2016/license.html).
* Copyright (c) 2016 Gabor Szelcsanyi

[![image](https://ga-beacon.appspot.com/UA-56493884-1/chef-redis/README.md)](https://github.com/szelcsanyi/chef-redis)
