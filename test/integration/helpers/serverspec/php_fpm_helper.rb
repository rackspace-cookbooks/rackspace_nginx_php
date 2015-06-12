shared_examples_for 'php-fpm' do |enabled_suite, disabled_suite|
  # Basic tests
  describe service(suite_family_value(enabled_suite, :fpm_service_name, os[:family].to_sym)) do
    it { should be_enabled }
    it { should be_running }
  end

  describe file(suite_family_value(enabled_suite, :fpm_socket, os[:family].to_sym)) do
    it { should be_socket }
  end

  describe file(suite_family_value(disabled_suite, :fpm_socket, os[:family].to_sym)) do
    it { should_not be_socket }
  end

  # Pool tests
  describe file(suite_family_value(enabled_suite, :default_pool, os[:family].to_sym)) do
    it { should be_file }
  end

  describe file(suite_family_value(disabled_suite, :default_pool, os[:family].to_sym)) do
    it { should_not be_file }
  end
end
