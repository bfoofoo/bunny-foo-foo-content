module Sms
  module Abstractsolutions
    class SubscriptionService
      attr_reader :params, :account

      def initialize(params: {}, account:nil)
        @account = account
        @params = params
      end

      def find_provider(user)
        begin
          new_param = params.merge({
                                     cellphones: [ user.try(:phone)] })
          response = client.lookup_provider(new_param)
        rescue => e
          puts "AbstractSolutions lookup  subscriber error - #{e}".red
        end
        response
      end

      def add(user)


        begin
          provider = find_provider(user)
          return if provider == -1
          new_params = params.merge({
                                      member_info:{
                                        email: user.try(:email),
                                        optin_ip: params[:ip],
                                        first_name: user&.first_name,
                                        last_name: user&.last_name,
                                        cellphone: params[:phone],
                                        country_id:"223",
                                        carrier:provider,}
                                    })
          client.create_contact(new_params)
        rescue => e
          puts "AbstractSolutions adding subscriber error - #{e}".red
        end
      end

      private

      def client
        return @client if defined?(@client)
        @client = Sms::Abstractsolutions::ApiWrapperService.new(account: account, params: params)
      end

    end
  end
end
