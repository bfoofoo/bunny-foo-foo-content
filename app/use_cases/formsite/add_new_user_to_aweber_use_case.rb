class Formsite
  class AddNewUserToAweberUseCase
    attr_reader :formsite, :user, :formsite_user

    def initialize(formsite, user, formsite_user)
      context.fail! if !formsite_user.is_verified
      @user = user
      @formsite = formsite
    end

    def preform
      formsite.aweber_lists.each do |list| 
        EmailMarketerService::Aweber::SubscriptionsService.new(list: list).add_subscriber(user)
      end
    end

  end
end