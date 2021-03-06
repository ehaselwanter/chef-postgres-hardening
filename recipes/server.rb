# encoding: utf-8
#
# Cookbook Name: postgres-hardening
# Recipe: server.rb
#
# Copyright 2014, Deutsche Telekom AG
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

# installs the server
include_recipe 'postgresql::server'

case node['platform_family']
when 'debian'

  ['', node['postgresql']['version']].each do |dir|

    directory File.join('/var/lib/postgresql/', dir) do
      mode 0700
    end
  end

  change_notify = node['postgresql']['server']['config_change_notify']

  link "/var/lib/postgresql/#{node['postgresql']['version']}/main/server.crt" do
    action :delete
    only_if "ls -l /var/lib/postgresql/#{node['postgresql']['version']}/main/server.crt |grep /etc/ssl/certs/ssl-cert-snakeoil.pem"
    notifies change_notify, 'service[postgresql]'
  end

  link "/var/lib/postgresql/#{node['postgresql']['version']}/main/server.key" do
    action :delete
    only_if "ls -l /var/lib/postgresql/#{node['postgresql']['version']}/main/server.key |grep /etc/ssl/private/ssl-cert-snakeoil.key"
    notifies change_notify, 'service[postgresql]'
  end

end
