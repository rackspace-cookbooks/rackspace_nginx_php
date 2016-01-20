shared_examples_for 'Nginx' do |enabled_suite, disabled_suite|
  it 'includes nginx required recipes' do
    expect(chef_run).to include_recipe('nginx::default')
  end
  it 'creates the enabled site document root' do
    expect(chef_run).to create_directory("/var/www/#{enabled_suite}").with(
      owner: 'root',
      group: 'root',
      mode: '0755',
      recursive: true
    )
  end
  it 'does not create the disabled site document root' do
    expect(chef_run).to_not create_directory("/var/www/#{disabled_suite}")
  end
  it 'creates the enabled site configuration' do
    [
      'server {',
      'listen        80;',
      'server_name   Fauxhai;',
      "access_log    /var/log/nginx/#{enabled_suite}.access.log;",
      "error_log     /var/log/nginx/#{enabled_suite}.error.log;",
      'location / {',
      'index   index.html index.htm;',
      'location ~* \.php$ {',
      'try_files       $uri = 404;',
      'include         fastcgi_params;',
      "fastcgi_pass    unix:/var/run/php-fpm-#{enabled_suite}.sock;",
      'fastcgi_index   index.php;',
      'fastcgi_param   SCRIPT_FILENAME  $document_root$fastcgi_script_name;'
    ].each do |line|
      expect(chef_run).to render_file("/etc/nginx/sites-available/#{enabled_suite}.conf").with_content(line)
    end
  end
  it 'does not create the disabled site configuration' do
    expect(chef_run).to_not render_file("/etc/nginx/sites-available/#{disabled_suite}.conf")
  end
  it 'enables the site' do
    expect(chef_run).to enable_nginx_site(enabled_suite)
  end
end

shared_examples_for 'PHP-FPM' do |platform, suite|
  it 'includes php-fpm default recipe' do
    expect(chef_run).to include_recipe('php-fpm::default')
  end
  it 'creates the default php-fpm pool' do
    # We cannot test the php_fpm_pool as it is a definition not a resource
    if platform == 'redhat'
      expect(chef_run).to render_file("/etc/php-fpm.d/#{suite}.conf")
    elsif platform == 'ubuntu'
      expect(chef_run).to render_file("/etc/php5/fpm/pool.d/#{suite}.conf")
    else
      expect(chef_run).to render_file("/etc/php5/fpm/pool.d/#{suite}.conf")
    end
  end
end

shared_examples_for 'Yum IUS repo' do
  it 'configures the appropriate repository' do
    expect(chef_run).to include_recipe('yum-ius')
  end
end

shared_examples_for 'APT php repo' do |version|
  it 'configures the appropriate repository' do
    expect(chef_run).to add_apt_repository("php-#{version}")
  end
end

shared_examples_for 'PHP and PHP-fpm packages version 5.5 CENTOS' do
  it 'installs the correct php and php-fpm packages' do
    ['php55u-devel', 'php55u-cli', 'php55u-pear', 'php55u-fpm'].each do |pkg|
      expect(chef_run).to install_package(pkg)
    end
  end
end

shared_examples_for 'PHP and PHP-fpm packages version 5.6 CENTOS' do
  it 'installs the correct php and php-fpm packages' do
    ['php56u-devel', 'php56u-cli', 'php56u-pear', 'php56u-fpm'].each do |pkg|
      expect(chef_run).to install_package(pkg)
    end
  end
end

shared_examples_for 'PHP-fpm packages without PHP packages, version 5.6 CENTOS' do
  it 'installs the correct php and php-fpm packages' do
    expect(chef_run).to install_package('php56u-fpm')
    expect(chef_run).to_not install_package('php56u-pear')
  end
end

shared_examples_for 'PHP and PHP-fpm packages version 5.5 UBUNTU' do
  it 'installs the correct php and php-fpm packages' do
    %w(php5-cgi php5 php5-dev php5-cli php-pear php5-fpm).each do |pkg|
      expect(chef_run).to install_package(pkg)
    end
  end
end

shared_examples_for 'PHP and PHP-fpm packages version 5.6 UBUNTU' do
  it 'installs the correct php and php-fpm packages' do
    %w(php5-cgi php5 php5-dev php5-cli php-pear php5-fpm).each do |pkg|
      expect(chef_run).to install_package(pkg)
    end
  end
end

shared_examples_for 'PHP-fpm packages without PHP packages, version 5.6 UBUNTU' do
  it 'installs the correct php and php-fpm packages' do
    expect(chef_run).to install_package('php5-fpm')
    expect(chef_run).to_not install_package('php5-cgi')
  end
end
