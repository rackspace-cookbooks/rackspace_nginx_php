# comments!

include_recipe 'rackspace_nginx_php::default'

# included just to be sure there is no conflicts
include_recipe 'php::default' if node['rackspace_nginx_php']['php_packages_install']['enable']
