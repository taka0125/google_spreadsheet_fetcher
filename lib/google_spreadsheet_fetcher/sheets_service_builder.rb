require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'shellwords'

module GoogleSpreadsheetFetcher
  class SheetsServiceBuilder
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

    # @param [String] user_id
    # @param [GoogleSpreadsheetFetcher::Config] config
    # @param [String] application_name
    def initialize(user_id, config: nil, application_name: nil)
      @user_id = user_id
      @config = config || GoogleSpreadsheetFetcher.config
      @application_name = application_name
    end

    def build
      Google::Apis::SheetsV4::SheetsService.new.tap do |service|
        service.authorization = fetch_credentials
        service.client_options.application_name = @application_name if @application_name.present?
      end
    end

    private

    def fetch_credentials
      client_id = Google::Auth::ClientId.from_file(@config.client_secrets_file)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: @config.credential_store_file)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, @config.scopes, token_store)

      credentials = authorizer.get_credentials(@user_id)
      return credentials if credentials.present?

      url = authorizer.get_authorization_url(base_url: OOB_URI)
      escaped_url = url.shellescape
      system("open #{escaped_url}")
      puts "Open #{url} in your browser and enter the resulting code: "
      code = STDIN.gets
      authorizer.get_and_store_credentials_from_code(user_id: @user_id, code: code, base_url: OOB_URI)
    end
  end
end
