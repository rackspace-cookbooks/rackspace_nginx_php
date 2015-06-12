# Testing cookbook
# Test if the consumer can successfully overidde the default behaviour of our cookbook

# Disable our default site and pool
node.default['rackspace_nginx_php']['nginx']['default_site']['enable'] = false
node.default['rackspace_nginx_php']['php-fpm']['default_pool']['enable'] = false

# Create a php-fpm pool through the attribute exposed from upstream
node.default['php-fpm']['pools'] = {
  override: {
    enable: 'true',
    process_manager: 'dynamic',
    max_requests: 5000
  }
}

include_recipe 'rackspace_nginx_php::default'

# Create a nginx site to go with it
directory '/var/www/override' do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
end

template "#{node['nginx']['dir']}/sites-available/override.conf" do
  source 'override.conf.erb'
  cookbook 'rackspace_nginx_php_test'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

nginx_site 'override.conf' do
  enable true
end

# included just to be sure there is no conflicts
include_recipe 'php::default' if node['rackspace_nginx_php']['php_packages_install']['enable']
