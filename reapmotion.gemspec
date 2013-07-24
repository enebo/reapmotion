# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "reapmotion/version"

files = `git ls-files -- lib/* spec/* sample/*`.split("\n")

Gem::Specification.new do |s|
  s.name        = 'reapmotion'
  s.version     = ReapMotion::VERSION
  s.license     = 'Apache License, Version 2.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = 'Thomas E. Enebo'
  s.email       = 'tom.enebo@gmail.com'
  s.homepage    = 'http://github.com/enebo/reapmotion'
  s.summary     = %q{A thin Ruby wrapper around Java LeapMotion API}
  s.description = %q{A thin Ruby wrapper around Java LeapMotion API}

  s.rubyforge_project = "reapmotion"

  s.files         = files
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
  s.has_rdoc      = true
end
