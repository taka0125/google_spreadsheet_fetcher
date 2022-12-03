module GoogleSpreadsheetFetcher
  module Authorizer
    module Oauth2
      class Config
        attr_reader :client_secrets_json_path, :user_id, :token_store, :client_id

        def initialize(client_secrets_json_path: nil, user_id: nil, token_store: nil)
          @client_secrets_json_path = client_secrets_json_path || ::GoogleSpreadsheetFetcher.config.client_secrets_file
          @user_id = user_id || ::GoogleSpreadsheetFetcher.config.user_id
          @token_store = token_store || default_token_store
          @client_id = ::Google::Auth::ClientId.from_file(self.client_secrets_json_path)

          freeze
        end

        private

        def default_token_store
          store = ::GoogleSpreadsheetFetcher.config.token_store
          return store if store.present?

          file = ::GoogleSpreadsheetFetcher.config.credential_store_file
          ::Google::Auth::Stores::FileTokenStore.new(file: file)
        end
      end
    end
  end
end
