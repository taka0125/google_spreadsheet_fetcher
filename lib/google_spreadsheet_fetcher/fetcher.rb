require 'googleauth'
require 'googleauth/stores/file_token_store'
require "google/apis/sheets_v4"
require 'shellwords'

module GoogleSpreadsheetFetcher
  class Fetcher
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

    # @param [String] spreadsheet_id
    # @param [String] user_id
    # @param [GoogleSpreadsheetFetcher::Config] config
    # @param [String] application_name
    def initialize(spreadsheet_id, user_id, config: nil, application_name: nil)
      @spreadsheet_id = spreadsheet_id
      @user_id = user_id
      @config = config || GoogleSpreadsheetFetcher.config
      @application_name = application_name
    end

    # @param [String] range(https://developers.google.com/sheets/api/guides/concepts#a1_notation)
    # @param [Integer] skip
    def fetch_all_rows(range, skip: 0)
      rows = service.batch_get_spreadsheet_values(@spreadsheet_id, ranges: [range])&.value_ranges&.first&.values
      return [] if rows.blank?

      rows.slice!(0, skip)
      rows
    end

    def fetch_all_rows_by!(index: nil, sheet_id: nil, title: nil, skip: 0)
      sheet = fetch_sheet_by!(index: index, sheet_id: sheet_id, title: title)

      range = "#{sheet.properties.title}!A:Z"
      fetch_all_rows(range, skip: skip)
    end

    def service
      @service ||= Google::Apis::SheetsV4::SheetsService.new.tap do |service|
        service.authorization = fetch_credentials
        service.client_options.application_name = @application_name if @application_name.present?
      end
    end

    private

    def fetch_sheet_by!(index: nil, sheet_id: nil, title: nil)
      sheets = spreadsheet.sheets
      raise SheetNotFound if sheets.blank?

      return sheets[index] if index.present?
      return sheets.find { |s| s.properties.sheet_id == sheet_id } if sheet_id.present?
      return sheets.find { |s| s.properties.title == title } if title.present?

      raise SheetNotFound
    end

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

    def spreadsheet
      service.get_spreadsheet(@spreadsheet_id)
    end
  end
end
