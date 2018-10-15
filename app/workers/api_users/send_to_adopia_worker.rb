module ApiUsers
  class SendToAdopiaWorker
    include Sidekiq::Worker

    def perform
      api_users.each do |api_user|
        api_user.api_client_adopia_lists.each do |mapping|
          next unless mapping.should_send_now?(api_user.created_at) || api_user.sent_to_adopia_list?(mapping.destination)
          params = { affiliate: mapping.tag }.compact
          service_class.new(list: mapping.destination, params: params).add_contact(api_user)
        end
      end
    end

    private

    def api_users
      ApiUser.with_adopia_mappings.where.not(email_marketer_mappings: { delay_in_hours: 0 })
    end

    def service_class
      EmailMarketerService::Adopia::SubscriptionsService
    end
  end
end
