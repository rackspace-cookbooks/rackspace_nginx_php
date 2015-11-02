[![Circle CI](https://circleci.com/gh/rackspace-cookbooks/rackspace_nginx_php.svg?style=svg)](https://circleci.com/gh/rackspace-cookbooks/rackspace_nginx_php)

# rackspace_nginx_php-cookbook

A cookbook to provide a web server able to serve php pages with Nginx and PHP fpm.
It relies on [nginx cookbook](https://github.com/miketheman/nginx) and [php-fpm](https://github.com/yevgenko/cookbook-php-fpm). Those cookbooks are pinned on well known working minor version to prevent breaking changes.
In addition (even if this is not a requirement), the cookbook will install php packages through [PHP cookbook](https://github.com/opscode-cookbooks/php). Indeed most of the time you will need `php::default` in your role which will conflict with the `php-fpm` package if they are different.
You can disable the installation of php packages with `node['rackspace_nginx_php']['php_packages_install']['enable']`.


## *** 
## NOTE: Support for PHP 5.4 was dropped in v1.0.0
## ***

## Supported Platforms

* Centos 6.7
* Ubuntu 12.04
* Ubuntu 14.04 [(only PHP 5.5 and 5.6)](https://github.com/oerdnj/deb.sury.org/issues/58#issuecomment-92246112)

## Attributes

* `node['rackspace_nginx_php']['php_version']` : Which PHP version to install, default to PHP 5.6
* `node['rackspace_nginx_php']['php-fpm']['default_pool']['enable']` : Should it enable a default PHP-FPM pool which listens on a unix socket
* `node['rackspace_nginx_php']['nginx']['default_site']['enable']` : Should it enable a default Nginx site which passes requests for php files to the default php-fpm pool
* `node['rackspace_nginx_php']['nginx']['default_site']['cookbook']` : Where to find the template for the default Nginx site configuration , default to `rackspace_nginx_php cookbook`
* `node['rackspace_nginx_php']['nginx']['default_site']['template']` : The name of the template for the default Nginx site configuration , default to `default.conf.erb`

## Usage

Place a dependency on the rackspace_nginx_php cookbook in your cookbook's metadata.rb
```
depends 'rackspace_nginx_php'
```
Then, add `rackspace_nginx_php::default` to your runlist

```
# myrecipe.rb
include_recipe 'rackspace_nginx_php::default'
```

or

```
# roles/myrole.rb
name "myrole"
description "nginx and php role"
run_list(
  "rackspace_nginx_php::default"
)
```

You can change any of the `nginx`,`php-fpm` and `php` cookbook attributes to tune rackspace_nginx_php configuration.
** However you should not change ** `['php-fpm']['package_name']`,`['php-fpm']['service_name']` or `['php']['packages']` (as they are part of this cookbook logic) without checking it works.

## In scope

The goal of this library is to do the basic configuration to serve PHP pages through Nginx. It will only configure `Nginx` and a default site and pool, users are free to use that or disable it and create their own Nginx sites and PHP-FPM pools.

More in details it :

* Installs and configure Nginx web server
* Installs and configure php-fpm
* Installs and configure php
* Configures Nginx to serve php pages through php-fpm
* Gets the correct packages and change the configuration according to the php version

## Out of scope

Virtual Host are not managed by this cookbook, the configuration provided by this cookbook should not prevent users to extend php or php-fpm configuration.
As many features as possible should have a flag to enable/disable them, it will allow to enjoy some parts of the work done by this cookbook (get the correct packages by example) but still be able to configure your own php-fpm pools.


### Examples
#### Nginx and PHP 5.5

```
node.default['rackspace_nginx_php']['php_version'] = '5.5'
include_recipe 'rackspace_nginx_php::default'
```

#### Nginx and PHP 5.6

```
include_recipe 'rackspace_nginx_php::default'
```

#### Nginx and PHP 5.6 without the default Nginx site and PHP-FPM pool - Using attribute from upstream to define the pool

You will have to add your own Nginx site and PHP-FPM pool, here is an example using the upstream PHP-FPM attributes for the pool and a custom template for the Nginx site.

```
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

# Create a nginx site to go with it (the template must be created by the user)
template "#{node['nginx']['dir']}/sites-available/override.conf" do
  source 'override.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

nginx_site 'override.conf' do
  enable true
end

```

#### Nginx and PHP 5.6 without the default Nginx site and PHP-FPM pool - Using the php_fpm_pool definition to add a pool

You will have to add your own Nginx site and PHP-FPM pool, here is an example using the upstream PHP-FPM definition for the pool and a custom template for the Nginx site.

```
node.default['rackspace_nginx_php']['nginx']['default_site']['enable'] = false
node.default['rackspace_nginx_php']['php-fpm']['default_pool']['enable'] = false

# Create a php-fpm pool with default settings using the php_fpm_pool definition
php_fpm_pool 'override'

include_recipe 'rackspace_nginx_php::default'

# Create a nginx site to go with it (the template must be created by the user)
template "#{node['nginx']['dir']}/sites-available/override.conf" do
  source 'override.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

nginx_site 'override.conf' do
  enable true
end

```


## References

* [Nginx cookbook](https://github.com/miketheman/nginx)
* [PHP-fpm cookbook](https://github.com/yevgenko/cookbook-php-fpm)
* [PHP cookbook](https://github.com/opscode-cookbooks/php)


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Authors:: Kostas Georgakopoulos (kostas.georgakopoulos@rackspace.co.uk), Julien Berard (julien.berard@rackspace.co.uk)
