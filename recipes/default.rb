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

begin
  if node['platform_family'] == 'debian'
    include_recipe "rt4::_#{node['rt4']['install_method']}"
  else
    Chef::Log.warn('Install method: #{node['rt4']['install_method']} not supported in this distribution. Continuing with source install')
    node.set['rt4']['instal_method'] = 'source'
    include_recipe "rt4::_#{node['rt4']['install_method']}"
  end
rescue Chef::Exceptions::RecipeNotFound
  raise Chef::Exceptions::RecipeNotFound, "The install method " \
    "`#{node['rt4']['install_method']}' is not supported by " \
    "this cookbook. Please ensure you have spelled it correctly. If you " \
    "continue to encounter this error, please file an issue."
end

# Install the deps required depending on the db server.
case node['rt4']['db_server']
when 'mysql'
  include_recipe '_mysql'
when 'postgresql'
  include_recipe '_postgresql'
else
  Chef::Application.fatal!("Unsupported db_server type: #{node['rt4']['db_server']}")
end

# Install the deps required depending on the web server.
case node['rt4']['web_server']
when 'nginx'
  include_recipe 'rt4::_nginx'
when 'apache'
  include_recipe 'rt4::_apache'
else
  Chef::Application.fatal!("Unsupported web_server type: #{node['rt4']['web_server']}")
end
