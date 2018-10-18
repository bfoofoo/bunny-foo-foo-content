module FormsiteUsers
  class SendToEspWorker
    include Sidekiq::Worker

    def perform
      formsite_users.each do |formsite_user|
        formsite_user.send(list_method).each do |mapping|
          next unless mapping.should_send_now?(formsite_user.created_at)
          params = { affiliate: formsite_user.affiliate }.compact
          yield(params, mapping, formsite_user) if block_given?
        end
      end
    end

    private

    def formsite_users
      FormsiteUser
        .is_verified
        .where(email_marketer_list_users: { id: nil })
        .where.not(email_marketer_mappings: { delay_in_hours: 0 }, users: { id: nil })
    end

    def list_method
      raise NotImplementedError
    end
  end
end
