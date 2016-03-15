#
# Cookbook Name:: L7-redis
# Provider:: pool
#
# Copyright 2016, Gabor Szelcsanyi <szelcsanyi.gabor@gmail.com>

def whyrun_supported?
  true
end

action :remove do
  inst_port = new_resource.port || node['L7-redis']['config']['port']

  service "redis-server-#{new_resource.name}" do
    action [:stop, :disable]
  end

  file "/etc/init.d/redis-server-#{new_resource.name}" do
    action :delete
  end

  file "/etc/redis_#{new_resource.name}.conf" do
    action :delete
  end

  cron_d "redis-#{new_resource.name}-monitoring" do
    action :delete
  end

  file "/tmp/redis-monitoring-status-#{inst_port}" do
    action :delete
  end
end

action :create do
  Chef::Log.info("Redis pool: #{new_resource.name}")

  # allow per-instance config override
  inst_config = node['L7-redis']['config'].to_hash
  inst_config = inst_config.merge(new_resource.config) unless new_resource.config.nil?

  # support old resource settings
  inst_config['port'] = new_resource.port unless new_resource.port.nil?
  inst_config['bind'] = new_resource.bind unless new_resource.bind.nil?
  inst_config['timeout'] = new_resource.timeout unless new_resource.timeout.nil?
  inst_config['tcp-keepalive'] = new_resource.tcp_keepalive unless new_resource.tcp_keepalive.nil?
  inst_config['loglevel'] = new_resource.loglevel unless new_resource.loglevel.nil?
  inst_config['databases'] = new_resource.databases unless new_resource.databases.nil?
  inst_config['maxmemory'] = new_resource.maxmemory unless new_resource.maxmemory.nil?
  inst_config['maxmemory-policy'] = new_resource.maxmemory_policy unless new_resource.maxmemory_policy.nil?
  inst_config['maxmemory-samples'] = new_resource.maxmemory_samples unless new_resource.maxmemory_samples.nil?
  inst_config['slaveof'] = new_resource.slaveof unless new_resource.slaveof.nil?
  inst_config['slave-read-only'] = new_resource.slave_read_only unless new_resource.slave_read_only.nil?
  inst_config['stop-writes-on-bgsave-error'] = new_resource.stop_writes_on_bgsave_error unless new_resource.stop_writes_on_bgsave_error.nil?
  inst_config['unixsocketperm'] = new_resource.unixsocketperm unless new_resource.unixsocketperm.nil?
  inst_config['requirepass'] = new_resource.requirepass unless new_resource.requirepass.nil?
  inst_config['masterauth'] = new_resource.masterauth unless new_resource.masterauth.nil?
  inst_config['appendonly'] = new_resource.appendonly unless new_resource.appendonly.nil?
  inst_config['appendfsync'] = new_resource.appendfsync unless new_resource.appendfsync.nil?
  inst_config['no-appendfsync-on-rewrite'] = new_resource.no_appendfsync_on_rewrite unless new_resource.no_appendfsync_on_rewrite.nil?
  inst_config['auto-aof-rewrite-percentage'] = new_resource.auto_aof_rewrite_percentage unless new_resource.auto_aof_rewrite_percentage.nil?
  inst_config['auto-aof-rewrite-min-size'] = new_resource.auto_aof_rewrite_min_size unless new_resource.auto_aof_rewrite_min_size.nil?
  inst_config['aof-rewrite-incremental-fsync'] = new_resource.aof_rewrite_incremental_fsync unless new_resource.aof_rewrite_incremental_fsync.nil?

  # support old conditional definition of bgsave snapshot rules
  if !new_resource.snapshotting.nil? && new_resource.snapshotting == true
    inst_config['save'] = new_resource.snapshot_rules
  elsif new_resource.snapshotting == false
    inst_config['save'] = nil
  end

  # dir precedence: config[dir], old datadir parameter, '/var/lib/redis-poolname'
  unless inst_config.key?('dir') && !inst_config['dir'].nil?
    inst_config['dir'] = if new_resource.datadir.nil?
                           "/var/lib/redis-#{new_resource.name}"
                         else
                           new_resource.datadir
                         end
  end

  # override values of per-instance settings if not configured
  inst_config['pidfile'] = "/var/run/redis/redis-server-#{new_resource.name}.pid" if inst_config['pidfile'].nil?
  inst_config['unixsocket'] = "/var/run/redis/redis-#{new_resource.name}.sock" if inst_config['unixsocket'].nil?
  inst_config['logfile'] = "/var/log/redis/redis-server-#{new_resource.name}.log" if inst_config['logfile'].nil?
  inst_config['dbfilename'] = "dump-#{new_resource.name}.rdb" if inst_config['dbfilename'].nil?
  inst_config['appendfilename'] = "appendonly-#{new_resource.name}.aof" if inst_config['appendfilename'].nil?

  package 'redis-server' do
    action :install
  end

  directory inst_config['dir'] do
    action :create
    owner 'redis'
    group 'redis'
  end

  t = template "/etc/init.d/redis-server-#{new_resource.name}" do
    source 'etc/init.d/redis-server-pool.erb'
    cookbook 'L7-redis'
    owner 'root'
    group 'root'
    mode '0755'
    variables(name: new_resource.name)
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)

  t = template "/etc/redis/redis_#{new_resource.name}.conf" do
    source 'etc/redis/redis_pool.conf.erb'
    cookbook 'L7-redis'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      config: inst_config
    )
    notifies :restart, "service[redis-server-#{new_resource.name}]", :delayed
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)

  service "redis-server-#{new_resource.name}" do
    action [:enable, :start]
    supports status: true, restart: true
  end

  cron_d "redis-#{new_resource.name}-monitoring" do
    hour '*'
    minute '*'
    day '*'
    month '*'
    weekday '*'
    command "if timeout 3 /usr/bin/redis-cli -s /var/run/redis/redis-#{new_resource.name}.sock -a '#{inst_config['requirepass']}' INFO > /tmp/redis-monitoring-status-#{inst_config['port']}.tmp; then sleep 1; mv /tmp/redis-monitoring-status-#{inst_config['port']}.tmp /tmp/redis-monitoring-status-#{inst_config['port']}; else rm -f /tmp/redis-monitoring-status-#{inst_config['port']}.tmp; fi"
    user 'root'
    shell '/bin/bash'
  end

  # stop default instance
  service 'redis-server' do
    action [:stop, :disable]
    status_command '/etc/init.d/redis-server status'
  end
end
