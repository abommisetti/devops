override['addevops']['appname'] = "devops"


# Paths
default['adapache']['appsdir'] = {}
default['adapache']['appsdir']['base'] = "/apps/#{node['addevops']['appname']}"
default['adapache']['appsdir']['deployment'] = "#{node['adapache']['appsdir']['base']}/deployment"
default['adapache']['appsdir']['docroot'] = "#{node['adapache']['appsdir']['base']}/www"
default['adapache']['appsdir']['log'] = "#{node['adapache']['appsdir']['base']}/log"
default['adapache']['appsdir']['cachedir'] = "#{node['adapache']['appsdir']['base']}/cache"
default['adapache']['appsdir']['apachelog'] = "#{node['adapache']['appsdir']['log']}/http"
default['adapache']['appsdir']['tomcatlog'] = "#{node['adapache']['appsdir']['log']}/tomcat"
default['adapache']['appsdir']['sites'] = "/etc/httpd/sites-available/"
default['adapache']['deploy']['s3_url'] = "https://s3-us-west-2.amazonaws.com/ad-deployments"
default['adapache']['deploy']['s3_bucket'] = "ad-deployments"

# Apache setup
default['adapache']['apache_bind_path'] = '/'
# TODO: Should be able to get rid of enable_ssl and only use the OpsWorks app attribute
default['adapache']['enable_ssl'] = "true"

# Overrides for apache2
override['apache']['log_dir']       = node['adapache']['appsdir']['apachelog']
override['apache']['document_root'] = node['adapache']['appsdir']['docroot']
override['apache']['log_level'] = 'info rewrite:trace1'

default['apache']['default_modules'] = %w(
status alias auth_basic authn_core authn_file authz_core authz_groupfile
  authz_host authz_user autoindex dir env mime negotiation setenvif proxy_balancer
    proxy_http headers lbmethod_byrequests ssl log_config logio unixd remoteip cache cache_disk 
)