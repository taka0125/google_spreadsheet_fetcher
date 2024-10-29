require 'securerandom'

module GoogleSpreadsheetFetcher
  module Authorizer
    module Oauth2
      class RackApplication
        AUTHORIZE_PATH = '/authorize'.freeze
        CALLBACK_PATH = '/oauth2callback'.freeze

        def initialize(config: nil)
          @config = config || ::GoogleSpreadsheetFetcher::Authorizer::Oauth2::Config.new
          @authorizer = ::GoogleSpreadsheetFetcher::Authorizer::Oauth2::Authorizer.new(config: config)

          freeze
        end

        def call(env)
          path = env['PATH_INFO']
          request_method = env['REQUEST_METHOD']

          return handle_authorize(env) if path == AUTHORIZE_PATH && request_method == 'GET'
          return handle_callback(env) if path == CALLBACK_PATH && request_method == 'GET'

          plain_response(400, 'invalid access')
        end

        def cookie_settings(secret: nil)
          {
            domain: 'localhost',
            path: '/',
            expire_after: 3600*24,
            secret: secret || SecureRandom.hex(64)
          }
        end

        private

        attr_reader :config, :authorizer

        def handle_authorize(env)
          request = ::Rack::Request.new(env)

          credentials = authorizer.fetch_credentials
          if credentials.nil?
            redirect_url = authorizer.get_authorization_url(request)

            return redirect_response(redirect_url)
          end

          plain_response(200, 'authorized')
        end

        def handle_callback(env)
          request = ::Rack::Request.new(env)
          authorizer.handle_auth_callback(request)

          plain_response(200, 'token stored')
        end

        def redirect_response(url)
          [302, {'location' => url}, []]
        end

        def plain_response(status, text)
          [status, {'content-type' => 'text/plain'}, [text]]
        end
      end
    end
  end
end
