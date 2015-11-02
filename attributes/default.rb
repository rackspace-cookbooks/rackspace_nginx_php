# Desired PHP version - 5.5 and 5.6 are supported
default['rackspace_nginx_php']['php_version'] = '5.6'

# Disable the default pool from upstream php-fpm.
# We are adding this here instead of in our recipe to allow the consumer of rackspace_nginx_php to override the attribute.
default['php-fpm']['pools'] = {}

# Enable a default nginx site (proxy pass to php-fpm) and a default php-fpm pool.
default['rackspace_nginx_php']['nginx']['default_site']['template'] = 'default.conf.erb'
default['rackspace_nginx_php']['nginx']['default_site']['cookbook'] = 'rackspace_nginx_php'
default['rackspace_nginx_php']['nginx']['default_site']['enable'] = true
default['rackspace_nginx_php']['php-fpm']['default_pool']['enable'] = true

# PHP packages (not PHP-FPM)
default['rackspace_nginx_php']['php_packages_install']['enable'] = true
