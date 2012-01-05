#
# Cookbook Name:: driveclient
# Recipe:: default
#
# Copyright 2011, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "rackspace"
include_recipe "driveclient::repo"

case node[:platform]
  when "redhat", "centos"
    package "driveclient"
  when "ubuntu", "debian"
    rackspace_apt "driveclient" do
      action :install
    end
end

service "driveclient" do
  supports :restart => true, :stop => true
  action :enable
end

template node[:driveclient][:bootstrapfile] do
  source "bootstrap.json.erb"
  owner  "root"
  group  "root"
  mode   "0600"
  variables(
    :setup => true
  )
  not_if "grep 'Registered' #{node[:driveclient][:bootstrapfile]} |grep 'true'"
  notifies :start, resources(:service => "driveclient"), :immediately
end

log "Sleeping #{node[:driveclient][:sleep]}s to wait for Quattro registration."
ruby_block "Sleeping #{node[:driveclient][:sleep]}s" do
  block do
    sleep(node[:driveclient][:sleep])
  end
end

template "Check Registration" do
  path node[:driveclient][:bootstrapfile]
  source "bootstrap.json.erb"
  owner  "root"
  group  "root"
  mode   "0600"
  variables(
    :setup => false
  )
  not_if "grep 'Registered' #{node[:driveclient][:bootstrapfile]} |grep 'true'"
  notifies :stop, resources(:service => "driveclient"), :immediately
end
