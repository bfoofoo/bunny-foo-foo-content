module Messages
  class RecurringAutoResponseWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'messages'

    def perform
      auto_responses = MessageAutoResponse.where(followup: true, event: nil)
      return unless auto_responses.exists?

      auto_responses.each do |auto_response|
        events = MessageEvent
                   .where(event_type: MessageEvent::FOLLOWUP_EVENTS)
                   .where('message_events.created_at < ?', auto_response.delay_in_minutes.minutes.ago)
                   .where.not(message_auto_response_id: auto_response.id)
                   .order('message_events.created_at DESC')

        if auto_response.message_schedule_id
          events = events.joins(:message_schedule).where(message_schedules: { id: auto_response.message_schedule_id })
        end

        events.to_a.uniq_by(&:exported_lead_id).each do |event|
          lead = event.exported_lead
          service_class = ['EmailMarketerService', lead.list_type.underscore.split('_').first.capitalize, 'AutoRespond'].join('::').constantize
          service_class.new(list: auto_response.esp_list, auto_response: auto_response, lead: lead).call
        end
      end
    end
  end
end
