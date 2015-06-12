require 'spec_helper'

describe 'nginx tests' do
  it_behaves_like 'nginx', :default, :override # params denote 'enabled recipe' and 'disabled recipe'
end

describe 'php-fpm tests' do
  it_behaves_like 'php-fpm', :default, :override # params denote 'enabled recipe' and 'disabled recipe'
end

describe 'php tests' do
  it_behaves_like 'php with nginx', 5.5, :default
  it_behaves_like 'php', 5.5
end
