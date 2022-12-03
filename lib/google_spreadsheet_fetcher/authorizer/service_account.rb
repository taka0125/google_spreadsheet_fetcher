module GoogleSpreadsheetFetcher
  module Authorizer
    class ServiceAccount
      include Interface

      def initialize(credential, scope: nil)
        @credential = credential
        @scope = scope || ::GoogleSpreadsheetFetcher.config.scopes

        freeze
      end

      def setup!; end

      def fetch_credentials!(user_id: nil)
        ::Google::Auth::ServiceAccountCredentials.make_creds(
          json_key_io: StringIO.new(credential),
          scope: scope
        ).tap(&:fetch_access_token!)
      end

      private

      attr_reader :credential, :scope
    end
  end
end
