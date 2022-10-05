# frozen_string_literal: true

require_relative "lib/yarrrml_template_builder/version"

Gem::Specification.new do |spec|
  spec.name          = "yarrrml_template_builder"
  spec.version       = YARRRMLTemplateBuilder::VERSION
  spec.authors       = ["Mark Wilkinson"]
  spec.email         = ["markw@illuminae.com"]

  spec.summary       = "Creates YARRRML Template templates"
  spec.description   = "Creates a templated version of YARRRML, missing the source and iteration type so they can be reused"
  spec.homepage      = "https://github.com/ejp-rd-vp/CDE-semantic-model-implementations/tree/master/YARRRML_Tools/yarrrml_template_builder"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata["allowed_push_host"] = "http://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ejp-rd-vp/CDE-semantic-model-implementations/tree/master/YARRRML_Tools/yarrrml_template_builder"
  spec.metadata["changelog_uri"] = "https://github.com/ejp-rd-vp/CDE-semantic-model-implementations/tree/master/YARRRML_Tools/yarrrml_template_builder/Changelog.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_dependency "yaml", "~> 0.1.0"
  spec.add_dependency "rest-client", "~> 2.1.0"
  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
