module GoogleSpreadsheetFetcher
  class SheetsServiceBuilder
    # @param [String] user_id
    # @param [GoogleSpreadsheetFetcher::Config] config
    # @param [String] application_name
    def initialize(user_id, config: nil, application_name: nil)
      @user_id = user_id
      @config = config || GoogleSpreadsheetFetcher.config
      @application_name = application_name
    end

    def build(authorizer: nil)
      authorizer = authorizer || config.authorizer || ::GoogleSpreadsheetFetcher::Authorizer::Oauth2::Authorizer.new
      raise 'Authorizer is not configured' if authorizer.blank?

      ::Google::Apis::SheetsV4::SheetsService.new.tap do |service|
        service.authorization = authorizer.fetch_credentials!(user_id: user_id)
        service.client_options.application_name = application_name if application_name.present?
      end
    end

    private

    attr_reader :user_id, :config, :application_name
  end
end
