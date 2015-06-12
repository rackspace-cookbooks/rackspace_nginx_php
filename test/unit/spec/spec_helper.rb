require 'chefspec'
require 'chefspec/berkshelf'
require_relative 'rackspace_nginx_php_shared'

::LOG_LEVEL = ENV['CHEFSPEC_LOG_LEVEL'] ? ENV['CHEFSPEC_LOG_LEVEL'].to_sym : :fatal

def stub_resources
  stub_command('which nginx').and_return(true)
  stub_command('test -d /etc/php-fpm.d || mkdir -p /etc/php-fpm.d').and_return(true)
  stub_command('test -d /etc/php5/fpm/pool.d || mkdir -p /etc/php5/fpm/pool.d').and_return(true)
end

def node_resources(_node)
end

at_exit { ChefSpec::Coverage.report! }
