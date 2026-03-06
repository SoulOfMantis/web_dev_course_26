# frozen_string_literal: true

require_relative "lib/quadratic_ci/version"

Gem::Specification.new do |spec|
  spec.name          = "quadratic_ci"
  spec.version       = QuadraticCi::VERSION
  spec.authors       = ["Demo Author"]
  spec.email         = ["demo@example.com"]

  spec.summary       = "Quadratic equation solver with minitest and CI"
  spec.description   = "Demo gem with quadratic equation solver, minitest suite and GitHub Actions CI."
  spec.homepage      = "https://example.com/quadratic_ci"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.files = Dir.glob("lib/**/*.rb") + ["README.md", "Rakefile"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
