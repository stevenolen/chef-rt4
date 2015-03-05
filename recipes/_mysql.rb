#
# Cookbook Name:: rt4
# Recipe:: _mysql
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

# Installs mysql deps and the server itself if we expect it to run on localhost
  %w(libdbd-mysql-perl libmysqlclient18 mysql-client mysql-client-5.5 mysql-client-core-5.5 mysql-common).each do |pkg|
    package pkg
  end
if node['rt4']['db_host'] == 'localhost'
  mysql_service 'rt4' do
    port '3306'
    initial_root_password 'pleasechangeme'
    action [:create, :start]
  end
end
