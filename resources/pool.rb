#
# Cookbook Name:: L7-redis
# Resource:: pool
#
# Copyright 2016, Gabor Szelcsanyi <szelcsanyi.gabor@gmail.com>

actions :create, :remove

attribute :name, kind_of: String, name_attribute: true
attribute :cookbook, kind_of: String, default: 'L7-redis'
attribute :port, kind_of: [Integer, String, NilClass], default: nil
attribute :bind, kind_of: [String, NilClass], default: nil
attribute :unixsocketperm, kind_of: [Integer, String, NilClass], default: nil

attribute :timeout, kind_of: [Integer, String, NilClass], default: nil
attribute :tcp_keepalive, kind_of: [Integer, String, NilClass], default: nil

attribute :loglevel, kind_of: [String, NilClass], default: nil

attribute :databases, kind_of: [Integer, String, NilClass], default: nil
attribute :datadir, kind_of: [String, NilClass, NilClass], default: nil

attribute :maxmemory, kind_of: [String, NilClass], default: nil
attribute :maxmemory_policy, kind_of: [String, NilClass], default: nil
attribute :maxmemory_samples, kind_of: [Integer, String, NilClass], default: nil

attribute :slaveof, kind_of: [String, NilClass], default: nil
attribute :slave_read_only, kind_of: [String, NilClass], default: nil

attribute :masterauth, kind_of: [String, NilClass], default: nil

attribute :snapshotting, kind_of: [TrueClass, FalseClass, NilClass], default: nil
attribute :snapshot_rules, kind_of: Array, default: ['900 1', '300 10', '60 10000']

attribute :requirepass, kind_of: [String, NilClass], default: nil

attribute :stop_writes_on_bgsave_error, kind_of: [String, NilClass], default: nil

attribute :appendonly, kind_of: [String, NilClass], default: nil
attribute :appendfsync, kind_of: [String, NilClass], default: nil
attribute :no_appendfsync_on_rewrite, kind_of: [String, NilClass], default: nil
attribute :auto_aof_rewrite_percentage, kind_of: [Integer, String, NilClass], default: nil
attribute :auto_aof_rewrite_min_size, kind_of: [String, NilClass], default: nil
attribute :aof_rewrite_incremental_fsync, kind_of: [String, NilClass], default: nil

attribute :config, kind_of: [Hash, NilClass], default: nil

def initialize(*args)
  super
  @action = :create
end
