module Sms
  module Waypoint
    class SubscriptionService
      attr_reader :params, :account

      def initialize(params: {}, account:nil)
        @account = account
        @params = params
      end

      def add(user, leadgen_rev_site = nil)
        return unless valid?(user, leadgen_rev_site)
        new_params = params.merge({
                                    address1: params[:ip],
                                    firstname: user&.first_name,
                                    lastname: user&.last_name,
                                    phone1: params[:phone]
                                  })
        client.create_contact(new_params)
        mark_as_saved(user, leadgen_rev_site)
      rescue => e
        puts "Waypoint adding subscriber error - #{e}".red
      end

      private

      def client
        return @client if defined?(@client)
        @client = Sms::Waypoint::ApiWrapperService.new(account: account, params: params)
      end

      def valid?(user, leadgen_rev_site)
        if user.is_a?(ActiveRecord::Base)
          !SmsSubscriber.where(provider: 'Waypoint', linkable: user, source: leadgen_rev_site).exists?
        else
          true
        end
      end

      def mark_as_saved(user, leadgen_rev_site)
        SmsSubscriber.find_or_create_by(provider: 'Waypoint', linkable: user, source: leadgen_rev_site) if user.is_a?(ActiveRecord::Base)
      end
    end
  end
end
