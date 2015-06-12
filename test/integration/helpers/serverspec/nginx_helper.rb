shared_examples_for 'nginx' do |enabled_suite, disabled_suite|
  # Basic tests
  describe service(common_family_value(:nginx_service_name)) do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end

  # Configuration syntax test
  describe command("#{common_family_value(:nginx)} -t") do
    its(:exit_status) { should eq 0 }
  end

  # Site tests
  describe file(suite_family_value(enabled_suite, :docroot, os[:family].to_sym)) do
    it { should be_directory }
  end

  describe file(suite_family_value(disabled_suite, :docroot, os[:family].to_sym)) do
    it { should_not be_directory }
  end

  describe file(suite_family_value(enabled_suite, :default_site, os[:family].to_sym)) do
    it { should be_file }
  end

  describe file(suite_family_value(disabled_suite, :default_site, os[:family].to_sym)) do
    it { should_not be_file }
  end

  describe file(suite_family_value(enabled_suite, :default_site_enabled, os[:family].to_sym)) do
    it { should be_symlink }
    it { should be_linked_to suite_family_value(enabled_suite, :default_site, os[:family].to_sym) }
  end

  describe file(suite_family_value(disabled_suite, :default_site_enabled, os[:family].to_sym)) do
    it { should_not be_symlink }
    it { should_not be_linked_to suite_family_value(disabled_suite, :default_site, os[:family].to_sym) }
  end
end
