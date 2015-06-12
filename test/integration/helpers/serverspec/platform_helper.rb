# Encoding: utf-8
set :backend, :exec
set :path, '/sbin:/usr/local/sbin:/bin:/usr/bin:$PATH'

def suite_family_values
  suite_data = {
    default: {
      docroot: {
        redhat:  '/var/www/default',
        ubuntu:  '/var/www/default',
        other:   '/var/www/default'
      },
      default_site: {
        redhat:  '/etc/nginx/sites-available/default.conf',
        ubuntu:  '/etc/nginx/sites-available/default.conf',
        other:   '/etc/nginx/sites-available/default.conf'
      },
      default_site_enabled: {
        redhat:  '/etc/nginx/sites-enabled/default.conf',
        ubuntu:  '/etc/nginx/sites-enabled/default.conf',
        other:   '/etc/nginx/sites-enabled/default.conf'
      },
      default_pool: {
        redhat:  '/etc/php-fpm.d/default.conf',
        ubuntu:  '/etc/php5/fpm/pool.d/default.conf',
        other:   '/etc/php5/fpm/pool.d/default.conf'
      },
      fpm_service_name: {
        redhat:  'php-fpm',
        ubuntu:  'php5-fpm',
        other:   'php5-fpm'
      },
      fpm_socket: {
        redhat:  '/var/run/php-fpm-default.sock',
        ubuntu:  '/var/run/php-fpm-default.sock',
        other:   '/var/run/php-fpm-default.sock'
      }
    },
    override: {
      docroot: {
        redhat:  '/var/www/override',
        ubuntu:  '/var/www/override',
        other:   '/var/www/override'
      },
      default_site: {
        redhat:  '/etc/nginx/sites-available/override.conf',
        ubuntu:  '/etc/nginx/sites-available/override.conf',
        other:   '/etc/nginx/sites-available/override.conf'
      },
      default_site_enabled: {
        redhat:  '/etc/nginx/sites-enabled/override.conf',
        ubuntu:  '/etc/nginx/sites-enabled/override.conf',
        other:   '/etc/nginx/sites-enabled/override.conf'
      },
      default_pool: {
        redhat:  '/etc/php-fpm.d/override.conf',
        ubuntu:  '/etc/php5/fpm/pool.d/override.conf',
        other:   '/etc/php5/fpm/pool.d/override.conf'
      },
      fpm_service_name: {
        redhat:  'php-fpm',
        ubuntu:  'php5-fpm',
        other:   'php5-fpm'
      },
      fpm_socket: {
        redhat:  '/var/run/php-fpm-override.sock',
        ubuntu:  '/var/run/php-fpm-override.sock',
        other:   '/var/run/php-fpm-override.sock'
      }
    }
  }
  suite_data
end

def common_family_values
  common_data = {
    nginx:               '/usr/sbin/nginx',
    nginx_service_name:  'nginx'
  }
  common_data
end

def suite_family_value(suite, attribute, family)
  suite_family_values[suite][attribute][family]
end

def common_family_value(attribute)
  common_family_values[attribute]
end

def page_returns(url = 'http://localhost:80/', host = 'localhost', ssl = false)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.read_timeout = 70
  if ssl
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  req = Net::HTTP::Get.new(uri.request_uri)
  req.initialize_http_header('Host' => host)
  http.request(req).body
end
