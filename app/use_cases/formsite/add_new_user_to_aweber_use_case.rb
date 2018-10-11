class Formsite
  class AddNewUserToAweberUseCase
    attr_reader :formsite, :user, :formsite_user

    def initialize(formsite, user, formsite_user)
      @user = user
      @formsite = formsite
      @formsite_user = formsite_user
    end
    
    def perform
      return false if !formsite_user.is_verified || user.blank?
      params = { affiliate: formsite_user.affiliate }.compact
      lists.each do |list|
        EmailMarketerService::Aweber::SubscriptionsService.new(list: list.aweber_list, params: params).add_subscriber(user)
      end
    end

    def lists
      formsite
        .formsite_aweber_lists
        .joins(:aweber_list)
        .includes(:aweber_list)
        .where(formsite_aweber_lists: { delay_in_hours: 0 })
    end
  
  end
end
