shared_examples_for 'nginx' do |enabled_suite, disabled_suite|
  # Basic tests
  describe service(get_helper_data_value(enabled_suite, :nginx_service_name)) do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end

  # Configuration syntax test
  describe command("#{get_helper_data_value(enabled_suite, :nginx)} -t") do
    its(:exit_status) { should eq 0 }
  end

  # Site tests
  describe file(get_helper_data_value(enabled_suite, :docroot)) do
    it { should be_directory }
  end

  describe file(get_helper_data_value(disabled_suite, :docroot)) do
    it { should_not be_directory }
  end

  describe file(get_helper_data_value(enabled_suite, :default_site)) do
    it { should be_file }
  end

  describe file(get_helper_data_value(disabled_suite, :default_site)) do
    it { should_not be_file }
  end

  describe file(get_helper_data_value(enabled_suite, :default_site_enabled)) do
    it { should be_symlink }
    it { should be_linked_to get_helper_data_value(enabled_suite, :default_site) }
  end

  describe file(get_helper_data_value(disabled_suite, :default_site_enabled)) do
    it { should_not be_symlink }
    it { should_not be_linked_to get_helper_data_value(disabled_suite, :default_site) }
  end
end
