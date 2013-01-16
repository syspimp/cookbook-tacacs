#
# Cookbook Name:: tac-plus
# Recipe:: default
#
# Copyright 2011, AT&T
#
# All rights reserved - Do Not Redistribute
#

admins = search(
  :users, "tacacs_admin:#{node.chef_environment} OR tacacs_admin:all"
).map { |u| u['id'] }.uniq
viewers = search(
  :users, "tacacs_viewonly:#{node.chef_environment} OR tacacs_viewonly:all"
).map { |u| u['id'] }.uniq - admins

package "tacacs+" do
  action :upgrade
end

service "tacacs_plus" do
  supports :restart => true
  pattern "tac_plus"
end

directory node['tacacs']['log_dir'] do
  owner "root"
  group "root"

  action :create
end

template node['tacacs']['default'] do
  source "tacacs.erb"
  mode   0644

  notifies :restart, resources(:service => "tacacs_plus")
end

template node['tacacs']['config'] do
  source "tac_plus_conf.erb"
  mode   0640

  variables(
    :admins       => admins,
    :viewers      => viewers,
    :acc_log_path => node['tacacs']['acct_log_path'],
    :tac_key      => node['tacacs']['tac_key']
  )

  notifies :restart, resources(:service => "tacacs_plus")
end
