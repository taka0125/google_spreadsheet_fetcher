module GoogleSpreadsheetFetcher
  class Fetcher
    # @param [String] spreadsheet_id
    # @param [String] user_id
    # @param [GoogleSpreadsheetFetcher::Config] config
    # @param [String] application_name
    def initialize(spreadsheet_id, user_id, config: nil, application_name: nil)
      @spreadsheet_id = spreadsheet_id
      @user_id = user_id
      @config = config
      @application_name = application_name
    end

    def fetch_all_rows_by!(index: nil, sheet_id: nil, title: nil, skip: 0, structured: false)
      sheet = fetch_sheet_by!(index: index, sheet_id: sheet_id, title: title)
      fetch_all_rows(sheet, skip: skip, structured: structured)
    end

    def service
      @service ||= GoogleSpreadsheetFetcher::SheetsServiceBuilder.new(@user_id, config: @config, application_name: @application_name).build
    end

    private

    # @param [Google::Apis::SheetsV4::Sheet] sheet
    # @param [Integer] skip
    # @param [Boolean] structured
    def fetch_all_rows(sheet, skip: 0, structured: false)
      # https://developers.google.com/sheets/api/guides/concepts#a1_notation
      range = "#{sheet.properties.title}!A:ZZ"
      rows = service.get_spreadsheet_values(@spreadsheet_id, range)&.values
      return [] if rows.blank?

      headers = rows.first
      count = headers.count

      if structured
        rows.delete_at(0)
        rows.slice!(0, skip)
        rows.map { |r| headers.zip(r).to_h }
      else
        rows.slice!(0, skip)
        rows.map { |r| fill_array(r, count) }
      end
    end

    def fetch_sheet_by!(index: nil, sheet_id: nil, title: nil)
      sheets = spreadsheet.sheets
      raise SheetNotFound if sheets.blank?

      sheet = if index.present?
                sheets[index]
              elsif sheet_id.present?
                sheets.find { |s| s.properties.sheet_id == sheet_id }
              elsif title.present?
                sheets.find { |s| s.properties.title == title }
              end

      return sheet if sheet.present?

      raise SheetNotFound
    end

    def spreadsheet
      @spreadsheet ||= service.get_spreadsheet(@spreadsheet_id)
    end

    def fill_array(items, count, fill: "")
      items + (count - items.count).times.map { fill }
    end
  end
end
