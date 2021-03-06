# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

xenon_version = File.read(File.join(__dir__, 'VERSION'))

Gem::Specification.new do |spec|
  spec.name          = 'xenon'
  spec.version       = xenon_version
  spec.authors       = ['Greg Beech']
  spec.email         = ['greg@gregbeech.com']
  spec.summary       = %q{An HTTP framework for building RESTful APIs.}
  spec.description   = %q{Provides a model for the HTTP protocol and a tree-based routing syntax.}
  spec.homepage      = 'https://github.com/gregbeech/xenon'
  spec.license       = 'MIT'

  spec.files         = []
  spec.executables   = []
  spec.test_files    = []
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.2.0'

  spec.add_runtime_dependency 'xenon-http', xenon_version
  spec.add_runtime_dependency 'xenon-routing', xenon_version
end
