# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "crowd-auth/version"

Gem::Specification.new do |s|
  s.name          = "crowd-auth"
  s.version       = Crowd::Auth::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Ian Meyer"]
  s.email         = ["ianmmeyer@gmail.com"]
  s.homepage      = ""
  s.summary       = %q{Simple authentication against Atlassian Crowd}
  s.description   = %q{Simple authentication against Atlassian Crowd}

  s.rubyforge_project = "crowd-auth"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rest-client', '>= 1.6.1')
end