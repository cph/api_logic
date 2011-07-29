# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "api_logic/version"

Gem::Specification.new do |s|
  s.name        = "api_logic"
  s.version     = ApiController::VERSION
  s.authors     = ["Robert Lail"]
  s.email       = ["robert.lail@cph.org"]
  s.homepage    = ""
  s.summary     = %q{A lightweight mixin for making API controllers}
  s.description = %q{TODO: Write a gem description}
  
  s.rubyforge_project = "api_logic"
  
  s.add_dependency "activesupport"
  s.add_dependency "actionpack"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
