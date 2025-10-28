module GoogleSpreadsheetFetcher
  class Config
    class_attribute :authorizer

    class_attribute :client_secrets_file
    class_attribute :credential_store_file # required if token_store not set
    class_attribute :token_store # required if credential_store_file not set
    class_attribute :scopes
    class_attribute :user_id

    def self.default_config
      new.tap do |config|
        config.scopes = [::Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY]
      end
    end
  end
end
