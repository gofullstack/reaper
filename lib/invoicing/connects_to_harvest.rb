require 'harvested'

module Invoicing
  class ConnectsToHarvest

    class << self

      def connect(params = {})
        return unless block_given?

        client = Harvest.oauth_client 'api', params['access_token'], {:ssl => true}

        begin
          yield client
        rescue Harvest::BadRequest => e
          throw(:warden, :action => '400')
        rescue Harvest::AuthenticationFailed => e
          throw(:warden, :action => '401')
        rescue Harvest::NotFound => e
          throw(:warden, :action => '404')
        rescue Harvest::ServerError => e
          throw(:warden, :action => '500')
        rescue Harvest::Unavailable => e
          throw(:warden, :action => '502')
        rescue Harvest::RateLimited => e
          throw(:warden, :action => '503')
        rescue Harvest::InformHarvest => e
          throw(:warden, :action => 'oh_no')
        end
      end

    end

  end

  module HarvestOperations

    def as_harvest_user(user = nil, &block)
      user ||= self.user rescue self

      ConnectsToHarvest.connect(user, &block)
    end

  end
end
