#
# Cookbook Name:: L7-redis
# Provider:: pool
#
# Copyright 2016, Gabor Szelcsanyi <szelcsanyi.gabor@gmail.com>

def whyrun_supported?
  true
end

action :remove do
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

  file "/tmp/redis-monitoring-status-#{new_resource.port}" do
    action :delete
  end

end

action :create do
  Chef::Log.info("Redis pool: #{new_resource.name}")

  package 'redis-server' do
    action :install
  end

  if new_resource.datadir.nil?
    datadir = "/var/lib/redis-#{new_resource.name}"
  else
    datadir = new_resource.datadir
  end

  directory datadir do
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
      name: new_resource.name,
      port: new_resource.port,
      bind: new_resource.bind,
      timeout: new_resource.timeout,
      tcp_keepalive: new_resource.tcp_keepalive,
      loglevel: new_resource.loglevel,
      databases: new_resource.databases,
      datadir: datadir,
      maxmemory: new_resource.maxmemory,
      maxmemory_policy: new_resource.maxmemory_policy,
      maxmemory_samples: new_resource.maxmemory_samples,
      slaveof: new_resource.slaveof,
      slave_read_only: new_resource.slave_read_only,
      snapshotting: new_resource.snapshotting,
      snapshot_rules: new_resource.snapshot_rules,
      stop_writes_on_bgsave_error: new_resource.stop_writes_on_bgsave_error,
      unixsocketperm: new_resource.unixsocketperm,
      requirepass: new_resource.requirepass,
      masterauth: new_resource.masterauth,
      appendonly: new_resource.appendonly,
      appendfsync: new_resource.appendfsync,
      no_appendfsync_on_rewrite: new_resource.no_appendfsync_on_rewrite,
      auto_aof_rewrite_percentage: new_resource.auto_aof_rewrite_percentage,
      auto_aof_rewrite_min_size: new_resource.auto_aof_rewrite_min_size,
      aof_rewrite_incremental_fsync: new_resource.aof_rewrite_incremental_fsync
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
    command "if timeout 3 /usr/bin/redis-cli -s /var/run/redis/redis-#{new_resource.name}.sock -a '#{new_resource.requirepass}' INFO > /tmp/redis-monitoring-status-#{new_resource.port}.tmp; then sleep 1; mv /tmp/redis-monitoring-status-#{new_resource.port}.tmp /tmp/redis-monitoring-status-#{new_resource.port}; else rm -f /tmp/redis-monitoring-status-#{new_resource.port}.tmp; fi"
    user 'root'
    shell '/bin/bash'
  end

  # stop default instance
  service 'redis-server' do
    action [:stop, :disable]
    status_command '/etc/init.d/redis-server status'
  end

end
