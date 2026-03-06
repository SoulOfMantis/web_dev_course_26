# frozen_string_literal: true

require_relative "lib/quadratic_naive/version"

Gem::Specification.new do |spec|
  spec.name          = "quadratic_naive"
  spec.version       = QuadraticNaive::VERSION
  spec.authors       = ["Demo Author"]
  spec.email         = ["demo@example.com"]

  spec.summary       = "Naive quadratic equation solver"
  spec.description   = "Demo gem with naive quadratic equation solving and no tests."
  spec.homepage      = "https://example.com/quadratic_naive"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.files = Dir.glob("lib/**/*.rb") + ["README.md"]
  spec.require_paths = ["lib"]
end
