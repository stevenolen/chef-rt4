#
# Cookbook Name:: rt4
# Recipe:: _package
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

case node['platform']
when 'debian', 'ubuntu'
  # Install the request-tracker4 package (which grabs all of the code deps)
  package 'request-tracker4' do
    action :install
  end
  
  # Install the deps required depending on the db server.
  case node['rt4']['db_server']
  when 'mysql'
    %w(libdbd-mysql-perl libmysqlclient18 mysql-client mysql-client-5.5 mysql-client-core-5.5 mysql-common).each do |pkg|
      package pkg
    end
    include_recipe 'mysql::default' if node['rt4']['db_host'] == 'localhost'
  when 'postgresql'
    %w(libdbd-pg-perl libpq5 postgresql-client postgresql-client-9.3 postgresql-client-common).each do |pkg|
      package pkg
    end
    include_recipe 'postgresql::default' if node['rt4']['db_host'] == 'localhost'
  else
    Chef::Application.fatal!("Unsupported db_server type: #{node['rt4']['db_server']}")
  end


when 'redhat', 'centos', 'fedora'
  Chef::Log.warn('Install method: #{node['rt4']['install_method']} not supported in this distribution. Continuing with source install')
  include_recipe 'rt4::_source'
end
