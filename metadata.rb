# Encoding: utf-8
name 'rackspace_nginx_php'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Installs/Configures rackspace_nginx_php'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.4'

supports 'centos'
supports 'ubuntu'

depends 'apt'
depends 'nginx', '= 2.7.6'
depends 'chef-sugar'
depends 'php', '= 1.5.0'
depends 'php-fpm', '= 0.7.4'
depends 'yum-ius'
