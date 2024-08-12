require 'bundler'
Bundler.require

GoogleSpreadsheetFetcher.configure do |config|
  config.client_secrets_file = 'path_to_client_secret.json' # クライアント情報の保管場所
  config.credential_store_file = 'path_to_save_client_secret.json' # アクセストークンの保管場所
  config.user_id = 'sample'
end

app = GoogleSpreadsheetFetcher::Authorizer::Oauth2::RackApplication.new

use Rack::Session::Cookie, app.cookie_settings(secret: SecureRandom.hex(64))
run app