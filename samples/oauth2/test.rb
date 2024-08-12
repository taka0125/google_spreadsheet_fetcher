require 'bundler'
Bundler.require
require 'google_spreadsheet_fetcher'

GoogleSpreadsheetFetcher.configure do |config|
  config.client_secrets_file = 'path_to_client_secret.json' # クライアント情報の保管場所
  config.credential_store_file = 'path_to_save_client_secret.json' # アクセストークンの保管場所
  config.user_id = 'sample'

  # デフォルトで設定されるので未指定でも良い
  config.authorizer = ::GoogleSpreadsheetFetcher::Authorizer::Oauth2::Authorizer.new
end

sheet_key = 'example_sheet_id'

fetcher = GoogleSpreadsheetFetcher::Fetcher.new(sheet_key, GoogleSpreadsheetFetcher.config.user_id)

pp fetcher.fetch_all_rows_by!(index: 0)