module Messages
  class ReminderWoker
    include Sidekiq::Worker
    sidekiq_options queue: 'messages'

    def perform
      auto_responses = MessageAutoResponse.where(followup: true, event: 'nothing')
      return unless auto_responses.exists?

      auto_responses.each do |auto_response|
        leads = ExportedLead.joins_linkable.autoresponded.inactive_within(auto_response.delay_in_minutes)
        leads.each do |lead|
          service_class = ['EmailMarketerService', lead.list_type.underscore.split('_').first.capitalize, 'AutoRespond'].join('::').constantize
          service_class.new(list: auto_response.esp_list, auto_response: auto_response, lead: lead).call
        end
      end
    end
  end
end
