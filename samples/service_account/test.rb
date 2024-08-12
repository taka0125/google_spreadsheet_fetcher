require 'bundler'
Bundler.require
require 'google_spreadsheet_fetcher'

GoogleSpreadsheetFetcher.configure do |config|
  credential = Pathname.new('path_to_service_account_credential_file.json').read
  config.authorizer = ::GoogleSpreadsheetFetcher::Authorizer::ServiceAccount.new(credential)
  config.user_id = 'sample'
end

sheet_key = 'example_sheet_id'

fetcher = GoogleSpreadsheetFetcher::Fetcher.new(sheet_key, GoogleSpreadsheetFetcher.config.user_id)

pp fetcher.fetch_all_rows_by!(index: 0)