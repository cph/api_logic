# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "api_logic/version"

Gem::Specification.new do |s|
  s.name        = "api_logic"
  s.version     = ApiController::VERSION
  s.authors     = ["Robert Lail"]
  s.email       = ["robert.lail@cph.org"]
  s.homepage    = "https://github.com/boblail/api_logic"
  s.summary     = %q{A lightweight mixin for making API controllers}
  s.description = %q{Mixes in to ActionController and generates default RESTful actions automatically in a highly customizable way.}
  
  s.rubyforge_project = "api_logic"
  
  s.add_dependency "activesupport"
  s.add_dependency "actionpack"
  s.add_dependency "responders" #, "~> 2.0" # extracted from Rails 4.2
  
  s.files         = Dir.glob("{lib}/**/*") + %w(Gemfile Rakefile README.mdown)
  s.test_files    = []
  s.executables   = []
  s.require_paths = ["lib"]
end
