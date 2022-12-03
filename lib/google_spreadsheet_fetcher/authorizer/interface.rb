module GoogleSpreadsheetFetcher
  module Authorizer
    module Interface
      def fetch_credentials!(user_id: nil)
        raise NotImplementedError
      end
    end
  end
end
