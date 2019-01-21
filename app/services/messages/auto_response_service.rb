module Messages
  class AutoResponseService
    attr_reader :esp_list

    def initialize(esp_list)
      @esp_list = esp_list
    end

    def call(lead, followup = false, event = nil)
      return if MessageAutoResponse::AUTORESPONDING_ESPS.exclude?(esp_list.account.provider)
      # TODO this is bad, need to use EspList associations once it works
      conditions = { esp_list_id: esp_list.id, esp_list_type: esp_list.type, followup: followup }
      conditions[:event] = event if event && followup
      MessageAutoResponse.where(conditions).each do |m|
        params = [m.id, lead.id]
        m.instant? ? Messages::AutoResponseWorker.perform_async(*params) : Messages::AutoResponseWorker.perform_at(m.at, *params)
      end
      update_lead(lead, event)
    end

    private

    def update_lead(lead, event)
      case event
      when :click then lead.touch(:clicked_at)
      when :open then lead.touch(:opened_at)
      end
    end
  end
end
