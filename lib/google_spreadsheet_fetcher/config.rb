require 'active_support/configurable'

module GoogleSpreadsheetFetcher
  class Config
    attr_accessor :client_secrets_file_path
  end
end
