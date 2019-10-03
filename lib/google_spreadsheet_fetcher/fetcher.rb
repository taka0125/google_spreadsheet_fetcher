require 'googleauth'
require 'googleauth/stores/file_token_store'
require "google/apis/sheets_v4"
require 'shellwords'

module GoogleSpreadsheetFetcher
  class Fetcher
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

    def initialize(credential_store_file, user_id, sheet_key, application_name: nil)
      @client_secret_file = GoogleSpreadsheetFetcher.config.client_secrets_file_path
      @credential_store_file = credential_store_file
      @user_id = user_id
      @sheet_key = sheet_key
      @application_name = application_name
    end

    #
    # Fetch all rows
    #
    # @param [String] ranges https://developers.google.com/sheets/api/guides/concepts#a1_notation
    def fetch_all_rows(range, skip: 0)
      rows = service.batch_get_spreadsheet_values(@sheet_key, ranges: [range])&.value_ranges&.first&.values
      return if rows.empty?

      rows.slice!(0, skip)
      rows
    end

    def fetch_all_rows_by_index(index, skip: 0)
      sheet = sheet_by_index(index)
      raise if sheet.nil?

      range = "#{sheet.properties.title}!A:Z"
      fetch_all_rows(range, skip: skip)
    end

    def fetch_all_rows_by_gid(gid, skip: 0)
      sheet = sheet_by_gid(gid)
      raise if sheet.nil?

      range = "#{sheet.properties.title}!A:Z"
      fetch_all_rows(range, skip: skip)
    end

    def fetch_all_rows_by_title(title, skip: 0)
      sheet = sheet_by_title(title)
      raise if sheet.nil?

      range = "#{sheet.properties.title}!A:Z"
      fetch_all_rows(range, skip: skip)
    end

    def service
      @service ||= begin
        credentials = fetch_credentials

        service = Google::Apis::SheetsV4::SheetsService.new
        service.authorization = credentials
        service
      end
    end

    private

    def sheet_by_index(index)
      service.get_spreadsheet(@sheet_key).sheets[index]
    end

    def sheet_by_gid(gid)
      service.get_spreadsheet(@sheet_key).sheets.find { |s| s.properties.sheet_id == gid }
    end

    def sheet_by_title(title)
      service.get_spreadsheet(@sheet_key).sheets.find { |s| s.properties.title == title }
    end

    def fetch_credentials
      oob_uri = 'urn:ietf:wg:oauth:2.0:oob'

      client_id = Google::Auth::ClientId.from_file(@client_secret_file)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: @credential_store_file)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, scopes, token_store)

      credentials = authorizer.get_credentials(@user_id)

      if credentials.nil?
        url = authorizer.get_authorization_url(base_url: OOB_URI)
        escaped_url = url.shellescape
        system("open #{escaped_url}")
        puts "Open #{url} in your browser and enter the resulting code: "
        code = STDIN.gets
        credentials = authorizer.get_and_store_credentials_from_code(user_id: @user_id, code: code, base_url: oob_uri)
      end

      credentials
    end

    def scopes
      [
        Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY
      ]
    end
  end
end
