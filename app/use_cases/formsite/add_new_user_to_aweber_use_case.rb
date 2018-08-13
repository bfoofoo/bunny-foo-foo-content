class Formsite
  class AddNewUserToAweberUseCase
    attr_reader :formsite, :user

    def initialize(formsite, user)
      @user = user
      @formsite = formsite
    end

    def preform
      binding.pry
      formsite.aweber_lists.each do |list| 
        EmailMarketerService::Aweber::SubscriptionsService.new(list: list).add_subscriber(user)
      end
    end
  end
end