#
# Cookbook Name:: apache2_test
# Recipe:: mod_authz_listed_host
#
# Copyright 2012, Chef Software, Inc.
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

include_recipe 'apache2::default'
include_recipe 'apache2::mod_authz_host'

directory "#{node['apache_test']['root_dir']}/secure" do
  action :create
end

web_app 'secure' do
  template 'authz_host.conf.erb'
  remote_host_ip node['apache_test']['remote_host_ip']
end
