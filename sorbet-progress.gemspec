
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sorbet_progress/version"

Gem::Specification.new do |spec|
  spec.name = "sorbet-progress"
  spec.version = SorbetProgress::gem_version.to_s
  spec.authors = ["Jared Beck"]
  spec.email = ["jared@jaredbeck.com"]
  spec.summary = "Measure sorbet adoption progress"
  spec.homepage = "https://github.com/jaredbeck/sorbet-progress"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^test/}) }
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  lambda {
    range = [">= 0.4.4365", "<= 0.4.4366"]
    spec.add_runtime_dependency "sorbet", range
    spec.add_runtime_dependency "sorbet-runtime", range
  }.call

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "minitest", "~> 5.0"
end
