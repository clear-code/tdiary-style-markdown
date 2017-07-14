# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tdiary/style/markdown/version'

Gem::Specification.new do |spec|
  spec.name          = "tdiary-style-markdown"
  spec.version       = TDiary::Style::Markdown::VERSION
  spec.authors       = ["Kenji Okimoto"]
  spec.email         = ["okimoto@clear-code.com"]
  spec.description   = %q{Markdown Style for tDiary}
  spec.summary       = %q{Markdown Style for tDiary}
  spec.homepage      = "https://github.com/clear-code/tdiary-style-markdown"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'commonmarker'
  spec.add_dependency 'rouge'
  spec.add_dependency 'twitter-text'
  spec.add_dependency 'gemoji'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
end
