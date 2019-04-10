require 'active_support/configurable'

module GoogleSpreadsheetFetcher
  class Config
    include ActiveSupport::Configurable

    config_accessor :client_secrets_file
    config_accessor :credential_store_file
    config_accessor :scopes

    def self.default_config
      new.tap do |config|
        config.scopes = [Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY]
      end
    end
  end
end
