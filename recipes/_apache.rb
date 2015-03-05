#
# Cookbook Name:: rt4
# Recipe:: _apache
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

# Installs nginx and sets up spawn-fcgi rt4 route
%w(libfcgi-perl procps spawn-fcgi).each do |pkg|
  package pkg
end

include_recipe 'nginx'

cookbook_file node['init'] do
  source 'rt4-fcgi'
  user 'root'
  group 'root'
  mode '0755'
end

service 'rt4-fcgi' do
  supports start: true, restart: true, stop: true, status: false
  action [:enable, :start]
end

template "#{node['nginx']['dir']}/sites-available/rt4" do
  source "rt4_nginx.conf.erb"
  mode 0644
end

nginx_site "rt4" do
  action :enable
end
