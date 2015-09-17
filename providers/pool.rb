#
# Cookbook Name:: L7-redis
# Provider:: pool
#
# Copyright 2015, Gabor Szelcsanyi <szelcsanyi.gabor@gmail.com>

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
      unixsocketperm: new_resource.unixsocketperm,
      requirepass: new_resource.requirepass,
      masterauth: new_resource.masterauth
    )
    notifies :restart, "service[redis-server-#{new_resource.name}]", :delayed
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)

  service "redis-server-#{new_resource.name}" do
    action [:enable, :start]
    supports status: true, restart: true
  end

  # stop default instance
  service 'redis-server' do
    action [:stop, :disable]
    status_command '/etc/init.d/redis-server status'
  end

end
