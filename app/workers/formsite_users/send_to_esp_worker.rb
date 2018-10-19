module FormsiteUsers
  class SendToEspWorker
    include Sidekiq::Worker

    def perform
      mappings.each do |mapping|
        formsite_users = available_formsite_users(mapping.formsite.formsite_users)
        formsite_users = formsite_users.by_email_domain(mapping.domain) if mapping.domain
        formsite_users.each do |formsite_user|
          next unless mapping.should_send_now?(formsite_user.created_at)
          params = { affiliate: formsite_user.affiliate }.compact
          yield(params, mapping, formsite_user) if block_given?
        end
      end
    end

    private

    def mappings
      mapping_class.includes(formsite: :formsite_users).where.not(delay_in_hours: 0)
    end

    def mapping_class
      FormsiteMappings::Base
    end

    def list_to_user_association
      raise NotImplementedError
    end

    def available_formsite_users(formsite_users)
      formsite_users
        .is_verified
        .left_joins(user: list_to_user_association)
        .where(email_marketer_list_users: { id: nil })
        .where.not(users: { id: nil })
    end
  end
end
