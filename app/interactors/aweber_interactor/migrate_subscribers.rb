module AweberInteractor
  class MigrateSubscribers
    include Interactor

    def call
      rules.each do |rule|

        list_from = rule.list_from
        list_to   = rule.list_to

        subs_from_service = subscription_service(list_from)
        subs_to_service = subscription_service(list_to)

        puts "Start migrating subscribers from: #{list_from.full_name}".light_green
        migrate_subscribers(rule, list_from, list_to, subs_from_service, subs_to_service)
        puts "END migrating subscribers from: #{list_from.full_name}".light_green
      end
    end

    private

      def migrate_subscribers(rule, list_from, list_to, subs_from_service, subs_to_service)
        subscribers_from_service(subs_from_service, subscribers_params(rule)).each do |subscriber|
          id, subscriber = subscriber
          puts "Adding #{subscriber.name}:#{subscriber.email}".light_green
          subs_to_service.add_subscriber(subscriber)
          sleep(1)
        end
      end

      def subscribers_params rule
        return {
          "subscribed_at" => rule.time.to_i.day.ago.strftime("%m-%d-%Y")
        }
      end

      def subscribers_from_service service, search_params={}
        service.subscribers(search_params)
      end

      def rules
        return @rules if !@rules.blank?
        @rules = AweberRule.includes([list_to: [:aweber_account], list_from: [:aweber_account]]).all
      end

      def subscription_service(list)
        EmailMarketerService::Aweber::SubscriptionService.new(list)
      end
    

  end
end
