# Encoding: utf-8
set :backend, :exec
set :path, '/sbin:/usr/local/sbin:/bin:/usr/bin:$PATH'

def helper_data
  # Define the data we need to test every suite per platform and release
  # An attribute specific to a release but different across suites should go into >Family>Release>Suite>Attribute
  # An attribute specific to a release but common across suites should go into >Family>Release>Common>Attribute
  # An attribute common across releases but different across suites should go into >Family>Common>Suite>Attribute
  # An attribute common across releases and suites should go into >Family>Common>Attribute
  # An attribute common across releases and platforms but different across suites should go into >Common>Suite>Attribute
  # An attribute common across releases, platforms and suites should go into >Common>Attribute

  data = {
    redhat: {
      '6.7' => {
        default: {
          default_pool:         '/etc/php-fpm.d/default.conf',
          fpm_socket:           '/var/run/php-fpm-default.sock'
        },
        override: {
          default_pool:         '/etc/php-fpm.d/override.conf',
          fpm_socket:           '/var/run/php-fpm-override.sock'
        },
        common: {
          fpm_service_name:     'php-fpm'
        }
      },
      common: {
        default: {},
        override: {}
      }
    },
    ubuntu: {
      '12.04' => {
        default: {},
        override: {},
        common: {}
      },
      '14.04' => {
        default: {},
        override: {},
        common: {}
      },
      common: {
        fpm_service_name:       'php5-fpm',
        default: {
          default_pool:         '/etc/php5/fpm/pool.d/default.conf',
          fpm_socket:           '/var/run/php-fpm-default.sock'
        },
        override: {
          default_pool:         '/etc/php5/fpm/pool.d/override.conf',
          fpm_socket:           '/var/run/php-fpm-override.sock'
        }
      }
    },
    common: {
      nginx:                    '/usr/sbin/nginx',
      nginx_service_name:       'nginx',
      default: {
        docroot:                '/var/www/default',
        default_site:           '/etc/nginx/sites-available/default.conf',
        default_site_enabled:   '/etc/nginx/sites-enabled/default.conf'
      },
      override: {
        docroot:                '/var/www/override',
        default_site:           '/etc/nginx/sites-available/override.conf',
        default_site_enabled:   '/etc/nginx/sites-enabled/override.conf'
      }
    }
  }
  data
end

def get_helper_data_value(suite, attribute)
  # Return the attribute requested for this suite from most specific to less specific
  # >Family>Release>Suite>Attribute
  return helper_data[os[:family].to_sym][os[:release]][suite][attribute] unless helper_data[os[:family].to_sym][os[:release]][suite][attribute].nil?
  # >Family>Release>Common>Attribute
  return helper_data[os[:family].to_sym][os[:release]][:common][attribute] unless helper_data[os[:family].to_sym][os[:release]][:common][attribute].nil?
  # >Family>Common>Suite>Attribute
  return helper_data[os[:family].to_sym][:common][suite][attribute] unless helper_data[os[:family].to_sym][:common][suite][attribute].nil?
  # >Family>Common>Attribute
  return helper_data[os[:family].to_sym][:common][attribute] unless helper_data[os[:family].to_sym][:common][attribute].nil?
  # >Common>Suite>Attribute
  return helper_data[:common][suite][attribute] unless helper_data[:common][suite][attribute].nil?
  # >Common>Attribute
  return helper_data[:common][attribute] unless helper_data[:common][attribute].nil?
end
