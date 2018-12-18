module Messages
  class MassSendWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'messages'

    def perform(message_schedule_id)
      schedule = MessageSchedule.find(message_schedule_id)
      list_class = schedule.esp_list_type.constantize
      service_class = ['EmailMarketerService', list_class.provider.capitalize, 'SendMessage'].join('::').constantize
      result = service_class.new(list: schedule.esp_list, template: schedule.message_template, schedule: schedule).call
      schedule.update(state: 'sent') if result
    rescue => e
      schedule&.update(state: 'failed')
      logger.error(e.to_s)
      raise
    end
  end
end
