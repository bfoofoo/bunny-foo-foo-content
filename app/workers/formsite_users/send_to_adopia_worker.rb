module FormsiteUsers
  class SendToAdopiaWorker
    include Sidekiq::Worker

    def perform
      formsite_users.each do |formsite_user|
        formsite_user.formsite_adopia_lists.each do |mapping|
          next unless mapping.should_send_now?(formsite_user.created_at)
          params = { affiliate: formsite_user.affiliate }.compact
          service_class.new(list: mapping.adopia_list, params: params).add_contact(formsite_user)
        end
      end
    end

    private

    def formsite_users
      FormsiteUser
        .joins(:formsite_adopia_lists)
        .includes(:formsite_adopia_lists, :adopia_lists)
        .left_joins(user: :adopia_list_users)
        .where(email_marketer_list_users: { id: nil })
        .where.not(formsite_adopia_lists: { delay_in_hours: 0 }, users: { id: nil })
    end

    def service_class
      EmailMarketerService::Adopia::SubscriptionsService
    end
  end
end
