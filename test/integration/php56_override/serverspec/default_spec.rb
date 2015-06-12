require 'spec_helper'

describe 'nginx tests' do
  it_behaves_like 'nginx', :override, :default # params denote 'enabled recipe' and 'disabled recipe'
end

describe 'php-fpm tests' do
  it_behaves_like 'php-fpm', :override, :default # params denote 'enabled recipe' and 'disabled recipe'
end

describe 'php tests' do
  it_behaves_like 'php with nginx', 5.6, :override
  it_behaves_like 'php', 5.6
end
