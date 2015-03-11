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
#%w(libapache2-mod-perl2 libapache2-mod-fastcgi libapache-dbi-perl libapache2-mod-fcgid libapache2-mod-perl2).each do |pkg|
#  package pkg
#end

# Resolves lib deps as well as apache itself, let's not try harder.
package 'rt4-apache2'

template '/etc/apache2/sites-available/rt4.conf' do
	source 'rt4_apache.conf.erb'
	mode '0644'
end

link '/etc/apache2/sites-enabled/rt4.conf' do
  link_type :symbolic
  to '/etc/apache2/sites-available/rt4.conf'
end
