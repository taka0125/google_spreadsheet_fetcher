module GoogleSpreadsheetFetcher
  class SpreadsheetNotFound < StandardError; end
  class SheetNotFound < StandardError; end
  class InvalidSheetUrl < StandardError; end
end
