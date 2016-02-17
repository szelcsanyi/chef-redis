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

  inst_config = if new_resource.config.nil?
                  node['L7-redis']['config']
                else
                  node['L7-redis']['config'].merge(new_resource.config)
                end

  Chef::Log.info("DEBUG: inst_config = #{inst_config.inspect}")

  # support old resource settings
  inst_config.override['L7-redis']['config']['port'] = new_resource.port unless new_resource.port.nil?
  inst_config.override['L7-redis']['config']['bind'] = new_resource.bind unless new_resource.bind.nil?
  inst_config.override['L7-redis']['config']['timeout'] = new_resource.timeout unless new_resource.timeout.nil?
  inst_config.override['L7-redis']['config']['tcp_keepalive'] = new_resource.tcp_keepalive unless new_resource.tcp_keepalive.nil?
  inst_config.override['L7-redis']['config']['loglevel'] = new_resource.loglevel unless new_resource.loglevel.nil?
  inst_config.override['L7-redis']['config']['databases'] = new_resource.databases unless new_resource.databases.nil?
  inst_config.override['L7-redis']['config']['dir'] = new_resource.datadir unless new_resource.datadir.nil?
  # inst_config.override['L7-redis']['config']['maxmemory'] = new_resource.maxmemory unless new_resource.maxmemory.nil?
  inst_config.override['L7-redis']['config']['maxmemory_policy'] = new_resource.maxmemory_policy unless new_resource.maxmemory_policy.nil?
  inst_config.override['L7-redis']['config']['maxmemory_samples'] = new_resource.maxmemory_samples unless new_resource.maxmemory_samples.nil?
  inst_config.override['L7-redis']['config']['slaveof'] = new_resource.slaveof unless new_resource.slaveof.nil?
  inst_config.override['L7-redis']['config']['slave_read_only'] = new_resource.slave_read_only unless new_resource.slave_read_only.nil?
  inst_config.override['L7-redis']['config']['stop_writes_on_bgsave_error'] = new_resource.stop_writes_on_bgsave_error unless new_resource.stop_writes_on_bgsave_error.nil?
  inst_config.override['L7-redis']['config']['unixsocketperm'] = new_resource.unixsocketperm unless new_resource.unixsocketperm.nil?
  inst_config.override['L7-redis']['config']['requirepass'] = new_resource.requirepass unless new_resource.requirepass.nil?
  inst_config.override['L7-redis']['config']['masterauth'] = new_resource.masterauth unless new_resource.masterauth.nil?
  inst_config.override['L7-redis']['config']['appendonly'] = new_resource.appendonly unless new_resource.appendonly.nil?
  inst_config.override['L7-redis']['config']['appendfsync'] = new_resource.appendfsync unless new_resource.appendfsync.nil?
  inst_config.override['L7-redis']['config']['no_appendfsync_on_rewrite'] = new_resource.no_appendfsync_on_rewrite unless new_resource.no_appendfsync_on_rewrite.nil?
  inst_config.override['L7-redis']['config']['auto_aof_rewrite_percentage'] = new_resource.auto_aof_rewrite_percentage unless new_resource.auto_aof_rewrite_percentage.nil?
  inst_config.override['L7-redis']['config']['auto_aof_rewrite_min_size'] = new_resource.auto_aof_rewrite_min_size unless new_resource.auto_aof_rewrite_min_size.nil?
  inst_config.override['L7-redis']['config']['aof_rewrite_incremental_fsync'] = new_resource.aof_rewrite_incremental_fsync unless new_resource.aof_rewrite_incremental_fsync.nil?

  # support old conditional definition of bgsave snapshot rules
  if !new_resource.snapshotting.nil? && new_resource.snapshotting == True
    inst_config.override['L7-redis']['config']['save'] = new_resource.snapshot_rules
  elsif new_resource.snapshotting == False
    inst_config.override['L7-redis']['config']['save'] = nil
  end

  # override values of per-instance settings if not configured
  inst_config.override['L7-redis']['config']['pidfile'] = "/var/run/redis/redis-server-#{new_resource.name}.pid" if inst_config['L7-redis']['config']['pidfile'].nil?
  inst_config.override['L7-redis']['config']['unixsocket'] = "/var/run/redis/redis-#{new_resource.name}.sock" if inst_config['L7-redis']['config']['unixsocket'].nil?
  inst_config.override['L7-redis']['config']['logfile'] = "/var/log/redis/redis-server-#{new_resource.name}.log" if inst_config['L7-redis']['config']['logfile'].nil?
  inst_config.override['L7-redis']['config']['dbfilename'] = "dump-#{new_resource.name}.rdb" if inst_config['L7-redis']['config']['dbfilename'].nil?
  inst_config.override['L7-redis']['config']['appendfilename'] = "appendonly-#{new_resource.name}.aof" if inst_config['L7-redis']['config']['appendfilename'].nil?

  package 'redis-server' do
    action :install
  end

  directory inst_config['L7-redis']['config']['dir'] do
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
    command "if timeout 3 /usr/bin/redis-cli -s /var/run/redis/redis-#{new_resource.name}.sock -a '#{inst_config['L7-redis']['config']['requirepass']}' INFO > /tmp/redis-monitoring-status-#{inst_config['L7-redis']['config']['port']}.tmp; then sleep 1; mv /tmp/redis-monitoring-status-#{inst_config['L7-redis']['config']['port']}.tmp /tmp/redis-monitoring-status-#{inst_config['L7-redis']['config']['port']}; else rm -f /tmp/redis-monitoring-status-#{inst_config['L7-redis']['config']['port']}.tmp; fi"
    user 'root'
    shell '/bin/bash'
  end

  # stop default instance
  service 'redis-server' do
    action [:stop, :disable]
    status_command '/etc/init.d/redis-server status'
  end
end
