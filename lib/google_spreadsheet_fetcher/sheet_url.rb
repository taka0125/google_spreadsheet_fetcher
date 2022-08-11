require 'uri'

module GoogleSpreadsheetFetcher
  class SheetUrl
    HOST = 'docs.google.com'.freeze
    PATH_PATTERN = %r{spreadsheets/d/(?<spreadsheet_id>[^/]+)/edit}.freeze

    attr_reader :spreadsheet_id, :sheet_id

    private_class_method :new

    def initialize(spreadsheet_id, sheet_id)
      @spreadsheet_id = spreadsheet_id
      @sheet_id = sheet_id
      freeze
    end

    def url
      "https://#{self.class::HOST}/spreadsheets/d/#{spreadsheet_id}/edit#gid=#{sheet_id}"
    end

    def ==(other)
      return false unless other.class == self.class

      other.hash == hash
    end

    alias eql? ==

    def hash
      [spreadsheet_id, sheet_id].join.hash
    end

    class << self
      def parse!(url)
        uri = URI.parse(url)
        raise InvalidSheetUrl unless uri.host == HOST

        path_matched_result = uri.path.match(PATH_PATTERN)
        raise InvalidSheetUrl unless path_matched_result

        spreadsheet_id = path_matched_result[:spreadsheet_id]
        sheet_id = extract_sheet_id(uri.fragment)

        new(spreadsheet_id, sheet_id)
      end

      private

      def extract_sheet_id(fragment)
        return 0 if fragment.blank?

        results = Hash[*fragment.split('=')]
        results.dig('gid')&.to_i || 0
      end
    end
  end
end
