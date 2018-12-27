module Sms
  module AbstractSolutions
    class SubscriptionService
      SHORTDOMAIN_ID = 2.freeze

      attr_reader :params, :group, :cep_rule

      def initialize(params: {}, group: nil, cep_rule: nil)
        @group = group
        @cep_rule = cep_rule
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
        new_params = {
          subscriber_info:{
            email: user.try(:email),
            optin_ip: params[:ip],
            first_name: user&.first_name,
            last_name: user&.last_name,
            cellphone: params[:phone],
            country_id: "223",
            carrier: provider,
            #state: params[:state],
            zip: params[:zip]
          },
          custom_info: {
            SourceURL: params[:url]
          },
          client_id: client.session_params[:client_id],
          tcpa: 1,
          shortdomain_id: SHORTDOMAIN_ID,
          groups: [
            {
              group_id: group&.group_id,
              tcpa: 1
            }
          ],
          urls: [
            {
              url: "https://www.mydomain.com/extra/sdfasdf45asdg4asd",
              tag: "slideshow_url"
            }
          ]
        }
        response = client.add_subscriber(new_params)
        if response['status'] == 'success'
          id = response.dig('subscriber', 'id')
          mark_as_saved(user, leadgen_rev_site, id)
        end
        response
      rescue RequestError => e
        puts "AbstractSolutions adding subscriber error - #{e}".red
      end

      private

      def client
        return @client if defined?(@client)
        @client = Sms::AbstractSolutions::ApiWrapperService.new(account: group&.account)
      end

      def valid?(user, leadgen_rev_site)
        if user.is_a?(ActiveRecord::Base)
          !SmsSubscriber.where(provider: 'AbstractSolutions', linkable: user, source: leadgen_rev_site).exists?
        else
          true
        end
      end

      def mark_as_saved(user, leadgen_rev_site, id)
        if user.is_a?(ActiveRecord::Base)
          SmsSubscriber
            .create_with(cep_rule_id: cep_rule&.id, group_id: group&.id, id: id)
            .find_or_create_by(provider: 'AbstractSolutions', linkable: user, source: leadgen_rev_site)
        end
      end
    end
  end
end
