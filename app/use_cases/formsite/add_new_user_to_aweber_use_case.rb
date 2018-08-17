class Formsite
  class AddNewUserToAweberUseCase
    attr_reader :formsite, :user

    def initialize(formsite, user)
      context.fail! if !user.is_verified
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