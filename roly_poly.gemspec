# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roly_poly/version'

Gem::Specification.new do |spec|
  spec.name          = "roly_poly"
  spec.version       = RolyPoly::VERSION
  spec.authors       = ["Adrian Hooper"]
  spec.email         = ["adrian@euphoricpanda.co.uk"]

  spec.summary       = %q{A role management system with very fine-grained control over user roles}
  spec.description   = %q{
    RolyPoly allows users to be given very specific permissions within an app.
    Both roles, and the role assignment can be scoped to a resource, allowing
    for per-organisation roles to be defined.
  }
  spec.homepage      = "https://github.com/manageplaces/roly_poly"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '>= 3.2.0'
  spec.add_dependency 'railties', '>= 3.0.0'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "ammeter", "~> 1.1"
  spec.add_development_dependency "shoulda"
  spec.add_development_dependency "database_cleaner"
end
