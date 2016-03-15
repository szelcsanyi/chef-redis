default['L7-redis']['config']['daemonize'] = 'yes'
default['L7-redis']['config']['pidfile'] = nil
default['L7-redis']['config']['port'] = '6379'
default['L7-redis']['config']['bind'] = '127.0.0.1'
default['L7-redis']['config']['unixsocket'] = nil
default['L7-redis']['config']['unixsocketperm'] = '755'
default['L7-redis']['config']['timeout'] = '0'
default['L7-redis']['config']['tcp-keepalive'] = '0'
default['L7-redis']['config']['loglevel'] = 'notice'
default['L7-redis']['config']['logfile'] = nil
default['L7-redis']['config']['databases'] = '16'
default['L7-redis']['config']['save'] = [
  '900 1',
  '300 10',
  '60 10000'
]
default['L7-redis']['config']['stop-writes-on-bgsave-error'] = 'yes'
default['L7-redis']['config']['rdbcompression'] = 'no'
default['L7-redis']['config']['rdbchecksum'] = 'yes'
default['L7-redis']['config']['dbfilename'] = nil
default['L7-redis']['config']['dir'] = nil
default['L7-redis']['config']['requirepass'] = nil
default['L7-redis']['config']['slaveof'] = nil
default['L7-redis']['config']['slave-serve-stale-data'] = 'yes'
default['L7-redis']['config']['slave-read-only'] = 'yes'
default['L7-redis']['config']['masterauth'] = nil
default['L7-redis']['config']['maxclients'] = '10000'
default['L7-redis']['config']['maxmemory'] = '1gb'
default['L7-redis']['config']['maxmemory-policy'] = 'volatile-lru'
default['L7-redis']['config']['maxmemory-samples'] = '3'
default['L7-redis']['config']['appendonly'] = 'yes'
default['L7-redis']['config']['appendfilename'] = nil
default['L7-redis']['config']['appendfsync'] = 'everysec'
default['L7-redis']['config']['no-appendfsync-on-rewrite'] = 'no'
default['L7-redis']['config']['auto-aof-rewrite-percentage'] = '100'
default['L7-redis']['config']['auto-aof-rewrite-min-size'] = '64mb'
default['L7-redis']['config']['lua-time-limit'] = '5000'
default['L7-redis']['config']['slowlog-log-slower-than'] = '10000'
default['L7-redis']['config']['slowlog-max-len'] = '128'
default['L7-redis']['config']['hash-max-ziplist-entries'] = '512'
default['L7-redis']['config']['hash-max-ziplist-value'] = '64'
default['L7-redis']['config']['list-max-ziplist-entries'] = '512'
default['L7-redis']['config']['list-max-ziplist-value'] = '64'
default['L7-redis']['config']['set-max-intset-entries'] = '512'
default['L7-redis']['config']['zset-max-ziplist-entries'] = '128'
default['L7-redis']['config']['zset-max-ziplist-value'] = '64'
default['L7-redis']['config']['activerehashing'] = 'yes'
default['L7-redis']['config']['client-output-buffer-limit'] = [
  'normal 0 0 0',
  'slave 256mb 64mb 60',
  'pubsub 32mb 8mb 60'
]
default['L7-redis']['config']['hz'] = '10'
default['L7-redis']['config']['aof-rewrite-incremental-fsync'] = 'yes'
