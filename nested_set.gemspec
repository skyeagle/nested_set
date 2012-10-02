# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nested_set/version"

Gem::Specification.new do |s|
  s.name        = "nested_set"
  s.version     = NestedSet::VERSION
  s.authors     = ["Brandon Keepers", "Daniel Morrison"]
  s.email       = ["info@collectiveidea.com"]
  s.homepage    = "http://github.com/skyeagle/nested_set"
  s.summary     = %q{An awesome nested set implementation for Active Record}
  s.description = %q{An awesome nested set implementation for Active Record}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<railties>, [">= 3.0.0"])
  s.add_runtime_dependency(%q<activerecord>, [">= 3.0.0"])

  s.add_development_dependency(%q<rails>, [">= 3.0.0"])
  s.add_development_dependency(%q<sqlite3>, [">= 0"])
  s.add_development_dependency(%q<bench_press>, [">= 0.3.1"])
end
