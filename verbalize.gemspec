# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verbalize/version'

Gem::Specification.new do |spec|
  spec.name          = 'verbalize'
  spec.version       = Verbalize::VERSION
  spec.authors       = ['Zach Taylor']
  spec.email         = ['taylorzr@gmail.com']

  spec.summary       = 'Verb based class pattern'
  spec.homepage      = 'https://github.com/taylorzr/verbalize'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
end
