# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sorbet_progress/version"

Gem::Specification.new do |spec|
  spec.name = "sorbet-progress"
  spec.version = SorbetProgress.gem_version.to_s
  spec.licenses = ["AGPL-3.0-only"]
  spec.authors = ["Jared Beck"]
  spec.email = ["jared@jaredbeck.com"]
  spec.summary = "Measure sorbet adoption progress"
  spec.homepage = "https://github.com/jaredbeck/sorbet-progress"
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^test/}) }
  end
  spec.bindir = "bin"
  spec.executables = ["sorbet_progress"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.6.3"
  spec.required_rubygems_version = ">= 3.0.3"

  lambda {
    requirements = [">= 0.4.4314", "<= 0.4.4366"]
    spec.add_runtime_dependency "sorbet", requirements
    spec.add_runtime_dependency "sorbet-runtime", requirements
  }.call

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rubocop", "~> 0.72.0"
end
