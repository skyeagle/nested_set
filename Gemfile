source :rubygems

gemspec

case version = ENV['RAILS_VERSION'] || ">= 3.0.0"
when /3-0-stable/
  gem "rails", :git => "git://github.com/rails/rails.git", :branch => "3-0-stable"
  gem "arel",  :git => "git://github.com/rails/arel.git", :branch => "2-0-stable"
when /3-1-stable/
  gem "rails", :git => "git://github.com/rails/rails.git", :branch => "3-1-stable"
when /3-2-stable/
  gem "rails", :git => "git://github.com/rails/rails.git", :branch => "3-2-stable"
  gem "journey", '~> 1.0.4'
when /master/
  gem "rails", :git => "git://github.com/rails/rails.git"
  gem "arel", :git => "git://github.com/rails/arel.git"
  gem "journey", '~> 1.0.4'
else
  gem "rails", version
end
