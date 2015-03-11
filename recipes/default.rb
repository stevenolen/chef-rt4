#
# Cookbook Name:: rt4
# Recipe:: default
#
# Author: Steve Nolen <technolengy@gmail.com>
#
# Copyright (c) 2015.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'perl'
cpan_module 'Test::MockModule'

# testing different configs
#node.set['rt4']['web_server'] = 'apache'
#node.set['rt4']['db_server'] = 'postgresql'
#
## Install the deps required depending on the web server.
#case node['rt4']['web_server']
#when 'nginx'
#  include_recipe 'rt4::_nginx'
#when 'apache'
#  include_recipe 'rt4::_apache'
#else
#  Chef::Application.fatal!("Unsupported web_server type: #{node['rt4']['web_server']}")
#end
#
#begin
#  include_recipe "rt4::_#{node['rt4']['install_method']}"
#rescue Chef::Exceptions::RecipeNotFound
#  raise Chef::Exceptions::RecipeNotFound, "The install method #{node['rt4']['install_method']} is not supported by this cookbook."
#end
#
## Overwrite the RT_SiteConfig.pm file
#template "#{node['rt4']['conf_dir']}/RT_SiteConfig.pm" do
#  source 'RT_SiteConfig.pm.erb'
#  mode 0644
#end
#
## Install the deps required depending on the db server.
#case node['rt4']['db_server']
#when 'mysql'
#  include_recipe 'rt4::_mysql'
#  execute 'prep-db-mysql' do
#    command "/usr/sbin/rt-setup-database-4 --action init --dba root --dba-password #{node['rt4']['db_root_password']}"
#    only_if { `/usr/bin/mysql --host=#{node['rt4']['db_host']} --port=#{node['rt4']['db_port']} -u root -p#{node['rt4']['db_root_password']} -D mysql -r -B -N -e \"SELECT COUNT(*) FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '#{node['rt4']['db_name']}'\"`.to_i == 0 }
#  end
#when 'postgresql'
#  include_recipe 'rt4::_postgresql'
#  execute 'prep-db-psql' do
#    command "/usr/sbin/rt-setup-database-4 --action init --dba postgres --dba-password #{node['postgresql']['password']['postgres']}"
#    user 'postgres'
#    only_if { `su - postgres -c "/usr/bin/psql -l | grep #{node['rt4']['db_name']} | wc -l"`.to_i == 0 }
#  end
#else
#  Chef::Application.fatal!("Unsupported db_server type: #{node['rt4']['db_server']}")
#end
#
## init spawn-fcgi if we're doing nginx setup (can't do this until request-tracker4 package exists)
#service 'rt4-fcgi' do
#  supports start: true, restart: true, stop: true, status: true
#  action [:enable, :start]
#  only_if { node['rt4']['web_server'] == 'nginx' }
#end
#
#service 'apache2' do
#  supports start: true, restart: true, stop: true, status: true
#  action [:enable, :start]
#  only_if { node['rt4']['web_server'] == 'apache2' }
#end


