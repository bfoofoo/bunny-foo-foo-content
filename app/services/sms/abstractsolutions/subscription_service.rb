module Sms
  module Abstractsolutions
    class SubscriptionService
      attr_reader :params, :account

      def initialize(params: {}, account:nil)
        @account = account
        @params = params
      end

      def find_provider(cellphone)
        client.lookup_provider(cellphone: cellphone)
      rescue RequestError => e
        puts "AbstractSolutions lookup subscriber error - #{e}".red
      end

      def add(user, leadgen_rev_site = nil)
        return unless valid?(user, leadgen_rev_site)
        provider = find_provider(params[:phone])
        return if provider.nil?
        new_params = params.merge(
          member_info:{
            email: user.try(:email),
            optin_ip: params[:ip],
            first_name: user&.first_name,
            last_name: user&.last_name,
            cellphone: params[:phone],
            country_id: "223",
            carrier: provider
          }
        )
        response = client.create_contact(new_params)
        mark_as_saved(user, leadgen_rev_site) if response['status'] == 'success'
        response
      rescue RequestError => e
        puts "AbstractSolutions adding subscriber error - #{e}".red
      end

      private

      def client
        return @client if defined?(@client)
        @client = Sms::Abstractsolutions::ApiWrapperService.new
      end

      def valid?(user, leadgen_rev_site)
        if user.is_a?(ActiveRecord::Base)
          !SmsSubscriber.where(provider: 'AbstractSolutions', linkable: user, source: leadgen_rev_site).exists?
        else
          true
        end
      end

      def mark_as_saved(user, leadgen_rev_site)
        if user.is_a?(ActiveRecord::Base)
          SmsSubscriber.find_or_create_by(provider: 'AbstractSolutions', linkable: user, source: leadgen_rev_site)
        end
      end
    end
  end
end
