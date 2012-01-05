#
# Cookbook Name:: driveclient
# Recipe:: repo
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

case node[:platform]
when "redhat","centos"
  repo = cookbook_file "/etc/yum.repos.d/driveclient.repo" do
    source "driveclient.repo"
    action :nothing
  end
  repo.run_action(:create)
when "ubuntu"
  keyfile = cookbook_file "/tmp/repo-public.key" do
    source "repo-public.key"
    action :nothing
  end
  keyfile.run_action(:create)

  aptkey = execute "apt-key add /tmp/repo-public.key" do
    not_if "apt-key list | grep Rackspace"
    action :nothing
  end
  aptkey.run_action(:run)

  list = cookbook_file "/etc/apt/sources.list.d/driveclient.list" do
    source "driveclient.list"
    action :nothing
  end
  list.run_action(:create)

  apt = execute "update apt" do
    command "apt-get update"
    ignore_failure true
    action :nothing
  end
  begin
    apt.run_action(:run)
  rescue
    Chef::Log.warn("apt-get exited with non-0")
  end
end
