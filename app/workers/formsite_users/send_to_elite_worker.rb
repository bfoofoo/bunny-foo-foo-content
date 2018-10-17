module FormsiteUsers
  class SendToEliteWorker < SendToEspWorker
    def perform
      super do |params, mapping, formsite_user|
        EmailMarketerService::Elite::SubscriptionsService
          .new(group: mapping.elite_group, params: params)
          .add_contact(formsite_user.user)
      end
    end

    private

    def formsite_users
      super
        .joins(:formsite_elite_groups)
        .includes(:formsite_elite_groups, :elite_groups)
        .left_joins(user: :adopia_list_users)
    end

    def list_method
      :formsite_elite_groups
    end
  end
end
