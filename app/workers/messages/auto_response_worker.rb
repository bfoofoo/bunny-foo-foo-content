module Messages
  class AutoResponseWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'messages'

    def perform(auto_response_id, lead_id)
      auto_response = MessageAutoResponse.find(auto_response_id)
      lead = ExportedLead.find(lead_id)
      list_class = auto_response.esp_list_type.constantize
      service_class = ['EmailMarketerService', list_class.provider.capitalize, 'AutoRespond'].join('::').constantize
      service_class.new(list: auto_response.esp_list, template: auto_response.message_template, lead: lead).call
    end
  end
end