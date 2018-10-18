module FormsiteUsers
  class SendToOngageWorker < SendToEspWorker
    def perform
      super do |params, mapping, formsite_user|
        EmailMarketerService::Ongage::SubscriptionsService
          .new(list: mapping.ongage_list, params: params)
          .add_contact(formsite_user.user)
      end
    end

    private

    def formsite_users
      super
        .joins(:formsite_ongage_lists)
        .includes(:formsite_ongage_lists, :ongage_lists)
        .left_joins(user: :adopia_list_users)
    end

    def list_method
      :formsite_ongage_lists
    end
  end
end
