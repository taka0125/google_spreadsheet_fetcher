# https://github.com/googleapis/google-api-ruby-client/blob/main/docs/oauth-web.md

require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'googleauth/stores/file_token_store'

module GoogleSpreadsheetFetcher
  module Authorizer
    module Oauth2
      class Authorizer
        include Interface

        def initialize(config: nil, callback_uri: nil)
          @config = config || ::GoogleSpreadsheetFetcher::Authorizer::Oauth2::Config.new
          @callback_uri = callback_uri || ::GoogleSpreadsheetFetcher::Authorizer::Oauth2::RackApplication::CALLBACK_PATH
          @web_user_authorizer = build_web_user_authorizer

          freeze
        end

        def fetch_credentials!(user_id: nil)
          web_user_authorizer.get_credentials(user_id || config.user_id)
        end

        def fetch_credentials
          fetch_credentials!
        rescue StandardError
          nil
        end

        def get_authorization_url(rack_request)
          web_user_authorizer.get_authorization_url(request: rack_request)
        end

        def handle_auth_callback(rack_request)
          web_user_authorizer.handle_auth_callback(config.user_id, rack_request)
        end

        private

        attr_reader :config, :callback_uri, :web_user_authorizer

        def build_web_user_authorizer
          ::Google::Auth::WebUserAuthorizer.new(
            config.client_id, ::GoogleSpreadsheetFetcher.config.scopes, config.token_store, callback_uri
          )
        end
      end
    end
  end
end
