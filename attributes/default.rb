#
# Cookbook Name:: rt4
# Attributes:: default
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

default['rt4'].tap do |rt4|
  rt4['server_name'] = node['fqdn']
  rt4['install_method'] = 'package' # package or source
  rt4['version'] = 'latest' # generally only used for source install
  rt4['web_server'] = 'nginx' # one of nginx, apache
  rt4['db_server'] = 'mysql' # one of mysql, postgres
  rt4['db_host'] = 'localhost'
  rt4['db_name'] = 'rt4'
  rt4['db_user'] = 'rt4user'
  rt4['db_password'] = 'pleasechangeme'
  rt4['conf_dir'] = '/etc/request-tracker4/'

  case rt4['web_server']
  when 'nginx'
    rt4['init'] = '/etc/init.d/rt4-fcgi'
  end

  # RT_SiteConfig items
  rt4['org'] = 'Chef Cookbook'
  rt4['correspond_addr'] = 'rt4@example.org'
  rt4['comment_addr'] = 'rt4-comment@example.org'

end
