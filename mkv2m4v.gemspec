# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mkv2m4v/version'

Gem::Specification.new do |gem|
  gem.name          = "mkv2m4v"
  gem.version       = Mkv2m4v::VERSION
  gem.authors       = ["Ryan McGeary"]
  gem.email         = ["ryan@mcgeary.org"]
  gem.description   = Mkv2m4v::Description
  gem.summary       = %q{Makes Apple TV compatible videos}
  gem.homepage      = "https://github.com/rmm5t/mkv2m4v"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "trollop",   "~> 2.0"
  gem.add_dependency "mediainfo", "~> 0.7"
  gem.add_dependency "iso639",    "~> 1.1"
  gem.add_dependency "colorize",  "~> 0.5"

  gem.add_development_dependency "minitest",       "~> 4.3"
  gem.add_development_dependency "rake",           "~> 10.0"
end
