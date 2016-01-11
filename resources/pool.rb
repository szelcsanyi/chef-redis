#
# Cookbook Name:: L7-redis
# Resource:: pool
#
# Copyright 2015, Gabor Szelcsanyi <szelcsanyi.gabor@gmail.com>

actions :create, :remove

attribute :name, kind_of: String, name_attribute: true
attribute :cookbook, kind_of: String, default: 'L7-redis'
attribute :port, kind_of: [Integer, String], default: '6379'
attribute :bind, kind_of: [String], default: '127.0.0.1'
attribute :unixsocketperm, kind_of: [Integer, String], default: '755'

attribute :timeout, kind_of: [Integer, String], default: '0'
attribute :tcp_keepalive, kind_of: [Integer, String], default: '0'

attribute :loglevel, kind_of: [String], default: 'notice'

attribute :databases, kind_of: [Integer, String], default: '16'
attribute :datadir, kind_of: [String, NilClass], default: nil

attribute :maxmemory, kind_of: [String], default: '1gb'
attribute :maxmemory_policy, kind_of: [String], default: 'volatile-lru'
attribute :maxmemory_samples, kind_of: [Integer, String], default: '3'

attribute :slaveof, kind_of: [String, NilClass], default: nil
attribute :slave_read_only, kind_of: [String], default: 'yes'

attribute :masterauth, kind_of: [String, NilClass], default: nil

attribute :snapshotting, kind_of: [TrueClass, FalseClass], default: true
attribute :snapshot_rules, kind_of: Array, default: ['900 1', '300 10', '60 10000']

attribute :requirepass, kind_of: [String, NilClass], default: nil

attribute :stop_writes_on_bgsave_error, kind_of: String, default: 'yes'

def initialize(*args)
  super
  @action = :create
end
