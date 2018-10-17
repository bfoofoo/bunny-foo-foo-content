module FormsiteUsers
  class SendToAweberWorker < SendToEspWorker
    def perform
      super do |params, mapping, formsite_user|
        EmailMarketerService::Aweber::SubscriptionsService
          .new(list: mapping.aweber_list, params: params)
          .add_subscriber(formsite_user.user)
      end
    end

    private

    def formsite_users
      super
        .joins(:formsite_aweber_lists)
        .includes(:formsite_aweber_lists, :aweber_lists)
        .left_joins(user: :aweber_list_users)
    end

    def list_method
      :formsite_aweber_lists
    end
  end
end
