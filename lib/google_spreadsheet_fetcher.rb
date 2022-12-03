require 'active_support'
require 'active_support/json'
require 'active_support/core_ext'
require 'googleauth'
require 'google/apis/sheets_v4'

require 'google_spreadsheet_fetcher/version'
require 'google_spreadsheet_fetcher/config'
require 'google_spreadsheet_fetcher/error'
require 'google_spreadsheet_fetcher/authorizer/interface'
require 'google_spreadsheet_fetcher/authorizer/service_account'
require 'google_spreadsheet_fetcher/authorizer/oauth2/config'
require 'google_spreadsheet_fetcher/authorizer/oauth2/rack_application'
require 'google_spreadsheet_fetcher/authorizer/oauth2/authorizer'
require 'google_spreadsheet_fetcher/fetcher'
require 'google_spreadsheet_fetcher/sheet_url'
require 'google_spreadsheet_fetcher/bulk_fetcher'
require 'google_spreadsheet_fetcher/sheets_service_builder'

module GoogleSpreadsheetFetcher
  def self.config
    @config ||= Config.default_config
  end

  def self.configure
    yield config
  end
end
