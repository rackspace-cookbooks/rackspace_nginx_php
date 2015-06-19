require_relative 'spec_helper'
require_relative 'centos66_options.rb'

describe 'rackspace_nginx_php_test::default on Centos 6.6' do
  before do
    stub_resources
  end

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(CENTOS66_SERVICE_OPTS) do |node|
      node_resources(node)
    end.converge('rackspace_nginx_php_test::default')
  end

  context 'Nginx' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS66_SERVICE_OPTS) do |node|
      end.converge('rackspace_nginx_php_test::default')
    end
    it_behaves_like 'Nginx', 'default', 'override'
    it_behaves_like 'PHP-FPM', 'redhat', 'default'
    it_behaves_like 'Yum IUS repo'
  end

  context 'disable PHP packages install' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS66_SERVICE_OPTS) do |node|
        node.set['rackspace_nginx_php']['php_packages_install']['enable'] = false
      end.converge('rackspace_nginx_php_test::default')
    end
    it_behaves_like 'Nginx', 'default', 'override'
    it_behaves_like 'PHP-FPM', 'redhat', 'default'
    it_behaves_like 'Yum IUS repo'
    it_behaves_like 'PHP-fpm packages without PHP packages, version 5.6 CENTOS'
  end

  context 'PHP 5.4' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS66_SERVICE_OPTS) do |node|
        node.set['rackspace_nginx_php']['php_version'] = '5.4'
      end.converge('rackspace_nginx_php_test::default')
    end
    it_behaves_like 'Nginx', 'default', 'override'
    it_behaves_like 'PHP-FPM', 'redhat', 'default'
    it_behaves_like 'Yum IUS repo'
    it_behaves_like 'PHP and PHP-fpm packages version 5.4 CENTOS'
  end

  context 'PHP 5.5' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS66_SERVICE_OPTS) do |node|
        node.set['rackspace_nginx_php']['php_version'] = '5.5'
      end.converge('rackspace_nginx_php_test::default')
    end
    it_behaves_like 'Nginx', 'default', 'override'
    it_behaves_like 'PHP-FPM', 'redhat', 'default'
    it_behaves_like 'Yum IUS repo'
    it_behaves_like 'PHP and PHP-fpm packages version 5.5 CENTOS'
  end

  context 'PHP 5.6' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS66_SERVICE_OPTS) do |node|
        node.set['rackspace_nginx_php']['php_version'] = '5.6'
      end.converge('rackspace_nginx_php_test::default')
    end
    it_behaves_like 'Nginx', 'default', 'override'
    it_behaves_like 'PHP-FPM', 'redhat', 'default'
    it_behaves_like 'Yum IUS repo'
    it_behaves_like 'PHP and PHP-fpm packages version 5.6 CENTOS'
  end
end
