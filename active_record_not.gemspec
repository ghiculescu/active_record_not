$:.push File.expand_path("../lib", __FILE__)
require "active_record_not/version"

Gem::Specification.new do |s|
  s.name          = "active_record_not"
  s.version       = ActiveRecordNot::VERSION
  s.authors       = ["Alex Ghiculescu"]
  s.email         = ["alexghiculescu@gmail.com"]
  s.homepage      = ""
  s.summary       = %q{Chain scopes with #not}
  s.description   = %q{Adds NOT logic to ActiveRecord}
  s.files         = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.homepage      = 'http://rubygems.org/gems/active_record_not'
  s.require_paths = ["lib"]
  s.add_runtime_dependency 'activerecord'
end