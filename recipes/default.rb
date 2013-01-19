#
# Cookbook Name:: tacacs
# Recipe:: default
#
# Copyright 2013, AT&T
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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
  pattern "tac_plus"
  supports :restart => true

  action [ :enable, :start ]
end

directory node['tacacs']['log_dir'] do
  owner "root"
  group "root"
  mode   00644
end

template node['tacacs']['default'] do
  source "tacacs.erb"
  owner  "root"
  group  "root"
  mode   00644

  notifies :restart, "service[tacacs_plus]"
end

template node['tacacs']['config'] do
  source "tac_plus_conf.erb"
  owner  "root"
  group  "root"
  mode   00640

  variables(
    :admins  => admins,
    :viewers => viewers
  )

  notifies :restart, "service[tacacs_plus]"
end
