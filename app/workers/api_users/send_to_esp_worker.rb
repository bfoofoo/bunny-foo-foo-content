module ApiUsers
  class SendToEspWorker
    include Sidekiq::Worker

    def perform
      api_users.each do |api_user|
        api_user.send(list_method).each do |mapping|
          next unless mapping.should_send_now?(api_user.created_at) || api_user.sent_to_aweber_list?(mapping.destination)
          params = { affiliate: mapping.tag }.compact
          yield(params, mapping, api_user) if block_given?
        end
      end
    end

    private

    def api_users
      ApiUser.verified.where.not(email_marketer_mappings: { delay_in_hours: 0 })
    end

    def list_method
      raise NotImplementedError
    end
  end
end
