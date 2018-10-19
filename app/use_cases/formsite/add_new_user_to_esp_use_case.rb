class Formsite
  class AddNewUserToEspUseCase
    attr_reader :formsite, :user, :formsite_user

    def initialize(formsite, user, formsite_user)
      @user = user
      @formsite = formsite
      @formsite_user = formsite_user
    end

    def perform
      return false if !formsite_user.is_verified || user.blank?
      params = { affiliate: formsite_user.affiliate }.compact
      mappings.each do |mapping|
        next if mapping.domain && !formsite_user.email =~ /@#{Regexp.quote(mapping.domain)}\.\w+$/
        yield(mapping, user, params) if block_given?
      end
    end

    def mappings
      formsite.send(mapping_association).where(email_marketer_mappings: { delay_in_hours: 0 })
    end

    def mapping_association
      raise NotImplementedError
    end
  end
end
