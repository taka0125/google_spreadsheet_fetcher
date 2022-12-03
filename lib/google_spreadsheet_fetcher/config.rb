require 'active_support/configurable'

module GoogleSpreadsheetFetcher
  class Config
    include ActiveSupport::Configurable

    config_accessor :authorizer

    config_accessor :client_secrets_file
    config_accessor :credential_store_file # required if token_store not set
    config_accessor :token_store # required if credential_store_file not set
    config_accessor :scopes
    config_accessor :user_id

    def self.default_config
      new.tap do |config|
        config.scopes = [::Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY]
      end
    end
  end
end
