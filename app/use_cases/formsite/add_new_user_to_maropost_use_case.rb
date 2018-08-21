class Formsite
  class AddNewUserToMaropostUseCase
    attr_reader :formsite, :user, :formsite_user

    def initialize(formsite, user, formsite_user)
      @user = user
      @formsite = formsite
      @formsite_user = formsite_user
    end

    def perform
      return false if !formsite_user.is_verified || user.blank?
      formsite.maropost_lists.each do |list|
        EmailMarketerService::Maropost::Subscription.new(list: list).add_subscriber(user)
      end
    end
  end
end