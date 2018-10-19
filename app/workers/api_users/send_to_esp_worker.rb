module ApiUsers
  class SendToEspWorker
    include Sidekiq::Worker

    def perform
      mappings.each do |mapping|
        api_users = available_api_users(mapping.api_client.api_users)
        api_users = api_users.by_email_domain(mapping.domain) if mapping.domain
        api_users.each do |api_user|
          next unless mapping.should_send_now?(api_user.created_at)
          params = { affiliate: api_user.affiliate }.compact
          yield(params, mapping, api_user) if block_given?
        end
      end
    end

    private

    def mappings
      mapping_class.includes(api_client: :api_users).where.not(delay_in_hours: 0)
    end

    def mapping_class
      FormsiteMappings::Base
    end

    def list_to_user_association
      raise NotImplementedError
    end

    def available_api_users(api_users)
      api_users
        .verified
        .left_joins(list_to_user_association)
        .where(email_marketer_list_users: { id: nil })
    end
  end
end
