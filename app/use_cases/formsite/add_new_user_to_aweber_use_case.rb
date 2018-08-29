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
      formsite.aweber_lists.each do |list|
        EmailMarketerService::Aweber::SubscriptionsService.new(list: list, params: params).add_subscriber(user)
      end
    end
  
  end
end
