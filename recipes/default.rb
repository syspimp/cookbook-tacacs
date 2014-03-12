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
  :users, "tacacs:admin AND (admin:#{node.chef_environment} OR admin:all)"
).map { |u| u['id'] }.uniq
viewers = search(
  :users, "tacacs:viewonly AND (viewonly:#{node.chef_environment} OR viewonly:all)"
).map { |u| u['id'] }.uniq - admins

user_creds = Chef::EncryptedDataBagItem.load("user_passwords", node['tacacs']['robot']['username'])

package "tacacs+" do
  action :install
end

service "tacacs_plus" do
  pattern "tac_plus"
  supports :restart => true

  action [ :enable, :start ]
end

bash "hard_restart" do
  code <<-EOF
    service tacacs_plus stop
    /usr/bin/pkill tac_plus
    service tacacs_plus start
  EOF
  action :nothing
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

  notifies :run, "bash[hard_restart]"
end

template node['tacacs']['config'] do
  source "tac_plus_conf.erb"
  owner  "root"
  group  "root"
  mode   00640

  variables(
    :user_creds => user_creds,
    :admins  => admins,
    :viewers => viewers
  )

  notifies :run, "bash[hard_restart]"
end
