
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'financier/version'

Gem::Specification.new do |spec|
  spec.name          = 'financier'
  spec.version       = Financier::VERSION
  spec.authors       = ['Ethan Barron']
  spec.email         = ['ethan.barron@kalidy.com']

  spec.summary       = 'Provides handy financial calculators.'
  spec.description   = 'Ruby gem to deal with financial calculations.'
  spec.homepage      = 'https://rubygems.org/gems/financier'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = 'https://github.com/Inkybro/financier'
    # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0")
  end
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.bindir        = 'exe'

  spec.add_dependency 'activesupport', '>= 5.2.3'
  spec.add_dependency 'chronic', '>= 0.10.2'
  spec.add_dependency 'flt', '>= 1.5.0'

  spec.add_development_dependency 'bundler', '~> 2.0.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '>= 3.8.0'
  spec.add_development_dependency 'rubocop', '~> 0.67.2'
end
