#
# Cookbook Name:: rt4
# Recipe:: _postgresql
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

# Installs postgresql deps and the server itself if we expect it to run on localhost
%w(libdbd-pg-perl libpq5 postgresql-client postgresql-client-9.3 postgresql-client-common).each do |pkg|
  package pkg
end

node.set['rt4']['db_port'] = '5432'
include_recipe 'postgresql::server' if node['rt4']['db_host'] == 'localhost'
