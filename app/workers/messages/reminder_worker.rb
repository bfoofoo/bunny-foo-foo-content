module Messages
  class ReminderWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'messages'

    def perform
      auto_responses = MessageAutoResponse.where(followup: true, event: 'nothing')
      return unless auto_responses.exists?

      auto_responses.each do |auto_response|
        events = MessageEvent
                   .where('created_at < ?', auto_response.delay_in_minutes.minutes.ago)

        if auto_response.message_schedule_id
          events = events.where(message_schedule_id: auto_response.message_schedule_id)
        else
          events = events.where(event_type: :welcome)
        end

        events.select!(&:not_read)
        events.each do |event|
          lead = event.exported_lead
          service_class = ['EmailMarketerService', lead.list_type.underscore.split('_').first.capitalize, 'AutoRespond'].join('::').constantize
          service_class.new(list: auto_response.esp_list, auto_response: auto_response, lead: lead).call
        end
      end
    end
  end
end
