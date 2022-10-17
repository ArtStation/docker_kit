
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kuber_kit/version"

Gem::Specification.new do |spec|
  spec.name          = "kuber_kit"
  spec.version       = KuberKit::VERSION
  spec.authors       = ["Iskander Khaziev"]
  spec.email         = ["gvalmon@gmail.com"]

  spec.summary       = %q{Docker Containers Build & Deployment}
  spec.description   = %q{Docker Containers Build & Deployment}
  spec.homepage      = "https://github.com/ArtStation/kuber_kit"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.6.0"

  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.0.0')
    spec.add_dependency "contracts", '0.17.0'
  else
    spec.add_dependency "contracts", '0.16.0'
  end

  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.7.0')
    spec.add_dependency "dry-auto_inject", "~> 0.9.0"
    spec.add_dependency "dry-core", "~> 0.8.1"
    spec.add_dependency "dry-configurable", "~> 0.16.1"
    spec.add_dependency "dry-container", "~> 0.10.1"
  else
    spec.add_dependency "dry-auto_inject", "~> 0.8.0"
    spec.add_dependency "dry-core", "~> 0.7.1"
    spec.add_dependency "dry-configurable", "~> 0.12.1"
    spec.add_dependency "dry-container", "~> 0.7.2"
  end

  spec.add_dependency "thor"
  spec.add_dependency "cli-ui"
  spec.add_dependency "net-ssh"
  spec.add_dependency "tty-prompt"

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
