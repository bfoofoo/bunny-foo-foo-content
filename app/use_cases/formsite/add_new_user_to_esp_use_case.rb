class Formsite
  class AddNewUserToEspUseCase
    attr_reader :formsite, :user, :formsite_user

    def initialize(formsite, user, formsite_user)
      @user = user
      @formsite = formsite
      @formsite_user = formsite_user
    end

    def lists
      formsite.send(list_class).where(email_marketer_mappings: { delay_in_hours: 0 })
    end

    def list_class
      raise NotImplementedError
    end
  end
end
