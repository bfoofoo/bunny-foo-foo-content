module Messages
  class AutoResponseService
    attr_reader :esp_list

    def initialize(esp_list)
      @esp_list = esp_list
    end

    def call(lead)
      return if MessageAutoResponse::AUTORESPONDING_ESPS.exclude?(esp_list.account.provider)
      # TODO this is bad, need to use EspList associations once it works
      MessageAutoResponse.where(esp_list_id: esp_list.id, esp_list_type: esp_list.type).each do |m|
        params = [m.id, lead.id]
        m.instant? ? Messages::AutoResponseWorker.perform_async(*params) : Messages::AutoResponseWorker.perform_at(m.at, *params)
      end
    end
  end
end