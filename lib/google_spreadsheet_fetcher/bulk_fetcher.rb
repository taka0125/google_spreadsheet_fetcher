require 'google/apis/sheets_v4'
require 'shellwords'

module GoogleSpreadsheetFetcher
  class BulkFetcher
    # @param [String] spreadsheet_id
    # @param [String] user_id
    # @param [GoogleSpreadsheetFetcher::Config] config
    # @param [String] application_name
    def initialize(spreadsheet_id, user_id, config: nil, application_name: nil)
      @spreadsheet_id = spreadsheet_id
      @user_id = user_id
      @config = config || GoogleSpreadsheetFetcher.config
      @application_name = application_name

      @spreadsheet = nil
    end

    def fetch
      @spreadsheet = service.get_spreadsheet(@spreadsheet_id, fields: 'sheets(properties,data.rowData.values(formattedValue))')
      self
    end

    # @param [Integer] index
    # @param [Integer] sheet_id
    # @param [String] title
    # @param [Integer] skip
    # @param [Boolean] structured
    def all_rows_by!(index: nil, sheet_id: nil, title: nil, skip: 0, structured: false)
      sheet = sheet_by!(index: index, sheet_id: sheet_id, title: title)
      sheet_to_array(sheet, skip: skip, structured: structured)
    end

    def service
      @service ||= GoogleSpreadsheetFetcher::SheetsServiceBuilder.new(@user_id, config: @config, application_name: @application_name).build
    end

    private

    def sheet_by!(index: nil, sheet_id: nil, title: nil)
      raise SpreadsheetNotFound if @spreadsheet.sheets.blank?

      if index.present?
        return @spreadsheet.sheets.find { |sheet| sheet.properties.index == index }
      elsif sheet_id.present?
        return @spreadsheet.sheets.find { |sheet| sheet.properties.sheet_id == sheet_id }
      elsif title.present?
        return @spreadsheet.sheets.find { |sheet| sheet.properties.title == title }
      end

      raise SheetNotFound
    end

    def sheet_to_array(sheet, skip: 0, structured: false)
      sheet_data = sheet&.data&.first
      return [] if sheet_data.nil?

      rows = sheet_data.row_data.map do |row_data|
        values = row_data.values
        next [''] if values.nil?

        values.map { |cell| cell&.formatted_value || "" }
      end

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

    def fill_array(items, count, fill: '')
      items + (count - items.count).times.map { fill }
    end
  end
end