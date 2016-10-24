#
# Cookbook Name:: Devopstest
# Recipe:: devopstest
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

directory node['adapache']['appsdir']['base'] do
  owner "root"
  group "root"
  mode  "0755"
  action :create
  recursive true
end
group node[:apache][:group] do
  gid '48'
end
user node[:apache][:user] do
  comment 'apache'
  uid   '48'
  gid   'apache'
  home  '/etc/httpd'
  shell '/sbin/nologin'
end
directory node['adapache']['appsdir']['docroot'] do
  owner "apache"
  group "apache"
  mode  "0750"
  action :create
end
directory node['adapache']['appsdir']['deployment'] do
  owner "root"
  group "root"
  mode  "0750"
  action :create
  recursive true
end
directory node['adapache']['appsdir']['log'] do
  owner "root"
  group "root"
  mode  "0755"
  action :create
end
directory node['adapache']['appsdir']['cachedir'] do
  owner "root"
  group "root"
  mode  "0755"
  action :create
end
directory node['adapache']['appsdir']['apachelog'] do
  owner "apache"
  group "apache"
  mode  "0750"
  action :create
end
app = search(:aws_opsworks_app, "name:devops").first
if app['shortname'].downcase == node['addevops']['appname'].downcase
  # TODO: apache service startup does not cause the recipe to fail if Apache fails to start
  # Set up apache
  include_recipe "apache2::default"
  if app['environment']['appenv'] =~ /devops/
      web_app app['shortname'].downcase do
        docroot         node['adapache']['appsdir']['docroot']
        server_name     app['domains'].first
        server_aliases  app['domains'][1, app['domains'].size]
        template "default/apacheconfig.erb"
        environment_variables = ""
    end
  end
template "#{node[:apache][:dir]}"'/ssl/devops.crt' do
    source 'devops.crt.erb'
     owner "apache"
     group "apache"
    mode '0600'
    action :create
    notifies :restart, "service[apache2]"
  end
template "#{node[:apache][:dir]}"'/ssl/devops.key' do
    source 'devops.key.erb'
     owner "apache"
     group "apache"
    mode '0600'
    action :create
    notifies :restart, "service[apache2]"
  end
  template "#{node['adapache']['appsdir']['base']}"'/www/helloworld.html do
    source 'helloworld.html.erb'
     owner "apache"
     group "apache"
    mode '0600'
    action :create
    notifies :restart, "service[apache2]"
  end
end