#
# Cookbook Name:: cens-dhcp
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

node.set[:dhcp][:options]['domain-name-servers'] = "131.179.128.30, 131.179.128.16"
node.set[:dhcp][:parameters]['ddns-update-style'] = "none"
node.set[:dhcp][:networks] = [ '131.179.144.0_24' ]
node.set[:dhcp][:groups] = [ 'static', 'deny']
node.set[:dhcp][:parameters]['max-lease-time'] = "3600"
node.set[:dhcp][:parameters]['default-lease-time'] = "1800"
include_recipe "dhcp::server"