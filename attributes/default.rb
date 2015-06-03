# Desired PHP version
default['rackspace_nginx_php']['php_version'] = '5.6'

# PHP handler configuration
default['rackspace_nginx_php']['php_handler']['template'] = 'php-handler.conf.erb'
default['rackspace_nginx_php']['php_handler']['cookbook'] = 'rackspace_nginx_php'
default['rackspace_nginx_php']['php_handler']['enable'] = true

# PHP packages (not PHP-FPM)
default['rackspace_nginx_php']['php_packages_install']['enable'] = true
