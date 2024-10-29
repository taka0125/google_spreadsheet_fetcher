require_relative "lib/google_spreadsheet_fetcher/version"

Gem::Specification.new do |spec|
  spec.name          = "google_spreadsheet_fetcher"
  spec.version       = GoogleSpreadsheetFetcher::VERSION
  spec.authors       = ["Takahiro Ooishi", "Yuya Yokosuka"]
  spec.email         = ["taka0125@gmail.com", "yuya.yokosuka@gmail.com"]

  spec.summary       = %q{Google Spreadsheet fetcher}
  spec.description   = %q{Google Spreadsheet fetcher}
  spec.homepage      = "https://github.com/taka0125/google_spreadsheet_fetcher"
  spec.licenses      = ['MIT']

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files         = Dir['lib/**/*', 'exe/**/*', 'sig/**/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 3.1.0'

  spec.add_dependency 'rack', '~> 3'
  spec.add_dependency 'rackup'
  spec.add_dependency 'rack-session'
  spec.add_dependency 'google-api-client', '~> 0.9'
  spec.add_dependency 'googleauth'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
