# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google_spreadsheet_fetcher/version'

Gem::Specification.new do |spec|
  spec.name          = "google_spreadsheet_fetcher"
  spec.version       = GoogleSpreadsheetFetcher::VERSION
  spec.authors       = ["Takahiro Ooishi"]
  spec.email         = ["taka0125@gmail.com"]

  spec.summary       = %q{Google Spreadsheet fetcher}
  spec.description   = %q{Google Spreadsheet fetcher}
  spec.homepage      = "https://github.com/taka0125/google_spreadsheet_fetcher"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_dependency 'google-api-client', '~> 0.9'
  spec.add_dependency 'google_drive', '~> 2.1.3'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
