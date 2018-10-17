module FormsiteUsers
  class SendToAdopiaWorker < SendToEspWorker
    def perform
      super do |params, mapping, formsite_user|
        EmailMarketerService::Adopia::SubscriptionsService
          .new(list: mapping.adopia_list, params: params)
          .add_contact(formsite_user.user)
      end
    end

    private

    def formsite_users
      super
        .joins(:formsite_adopia_lists)
        .includes(:formsite_adopia_lists, :adopia_lists)
        .left_joins(user: :adopia_list_users)
    end

    def list_method
      :formsite_adopia_lists
    end
  end
end
