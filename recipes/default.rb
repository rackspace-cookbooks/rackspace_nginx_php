# Encoding: utf-8
#
# Cookbook Name:: rackspace_nginx_php
# Recipe:: default
#
# Copyright 2014, Rackspace
#

# We only support 5.5 and 5.6
if node['rackspace_nginx_php']['php_version'] != '5.5' && node['rackspace_nginx_php']['php_version'] != '5.6'
  Chef::Application.fatal!("PHP version #{node['rackspace_nginx_php']['php_version']} is not supported")
end

include_recipe 'chef-sugar'

# NGINX
# Disable the default site from the upstream nginx cookbook.
# We do that because the template source is hardcoded in upstream and we cannot override it.
# We will create owr own.
node.default['nginx']['default_site_enabled'] = false

include_recipe 'nginx'

# Create the document root to use for the default site we create
directory '/var/www/default' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
  only_if { node['rackspace_nginx_php']['nginx']['default_site']['enable'] }
end

# Configuration for our default site
template "#{node['nginx']['dir']}/sites-available/default.conf" do
  source node['rackspace_nginx_php']['nginx']['default_site']['template']
  cookbook node['rackspace_nginx_php']['nginx']['default_site']['cookbook']
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  only_if { node['rackspace_nginx_php']['nginx']['default_site']['enable'] }
end

# Enable (or not) our default site
nginx_site 'default.conf' do
  enable node['rackspace_nginx_php']['nginx']['default_site']['enable']
end

# PHP-FPM
# repo dependencies for php-fpm
#
php_fpm = {
  'rhel' => {
    '5.5' => {
      'php_packages' => ['php55u-pear', 'php55u-devel', 'php55u-cli', 'php55u-pear'],
      'php_fpm_package' => 'php55u-fpm',
      'service' => 'php-fpm'
    },
    '5.6' => {
      'php_packages' => ['php56u-pear', 'php56u-devel', 'php56u-cli', 'php56u-pear'],
      'php_fpm_package' => 'php56u-fpm',
      'service' => 'php-fpm'
    }
  },
  'debian' => {
    '5.5' => {
      'repo'    => 'http://ppa.launchpad.net/ondrej/php5/ubuntu',
      'php_packages' => ['php5-cgi', 'php5', 'php5-dev', 'php5-cli', 'php-pear'],
      'php_fpm_package' => 'php5-fpm',
      'service' => 'php5-fpm'
    },
    '5.6' => {
      'repo'    => 'http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu',
      'php_packages' => ['php5-cgi', 'php5', 'php5-dev', 'php5-cli', 'php-pear'],
      'php_fpm_package' => 'php5-fpm',
      'service' => 'php5-fpm'
    }
  }
}

# Platform PHP repositories
# RHEL
if platform_family?('rhel')
  include_recipe 'yum-ius'
elsif platform_family?('debian')
  # DEBIAN
  include_recipe 'apt'
  # using http://ppa rather than ppa: to be sure it passes firewall
  apt_repository "php-#{node['rackspace_nginx_php']['php_version']}" do
    uri          php_fpm[node['platform_family']][node['rackspace_nginx_php']['php_version']]['repo']
    keyserver    'hkp://keyserver.ubuntu.com:80'
    key          '14AA40EC0831756756D7F66C4F4EA0AAE5267A6C'
    components   ['main']
    distribution node['lsb']['codename']
  end
end

# PHP-FPM
# Set the correct php-fpm packages to install
node.default['php-fpm']['package_name'] = php_fpm[node['platform_family']][node['rackspace_nginx_php']['php_version']]['php_fpm_package']
node.default['php-fpm']['service_name'] = php_fpm[node['platform_family']][node['rackspace_nginx_php']['php_version']]['service']

# Set the correct user for php-fpm
node.default['php-fpm']['user'] = node['nginx']['user']
node.default['php-fpm']['group'] = node['nginx']['group']

include_recipe 'php-fpm::default'

# Create (or not) our default pool
php_fpm_pool 'default' do
  enable node['rackspace_nginx_php']['php-fpm']['default_pool']['enable']
end

# PHP
# Set the correct php packages to install
if node['rackspace_nginx_php']['php_packages_install']['enable']
  node.default['php']['packages'] = php_fpm[node['platform_family']][node['rackspace_nginx_php']['php_version']]['php_packages']
  include_recipe 'php::default'
  # Emptying php packages, to be sure if another cookbook tries to include php::default it
  # will not install unwanted php version. If a user decided to use override we assume he knows what he is doing.
  node.default['php']['packages'] = []
end

# TODO
# * downgrade / upgrade Nginx if required
# Refactor mapping outside of the recipe
