module Esp
  module LinkableMethods
    extend ActiveSupport::Concern

    included do
      has_many :exported_leads, as: :linkable
    end

    ESP_LIST_TYPES = {
      adopia: 'AdopiaList',
      elite: 'EliteGroup',
      netatlantic: 'NetatlanticList',
      mailgun: 'MailgunList',
      onepoint: 'OnepointList',
      allinbox: 'AllinboxList',      
      sparkpost: 'SparkpostList',
      getresponse: 'GetresponseList'
    }.freeze

    ESP_LIST_TYPES.each do |provider, type|
      define_method :"sent_to_#{provider}?" do
        exported_leads.where(list_type: type).exists?
      end
    end

    def sent_to_list?(list)
      exported_leads.where(list: list).exists?
    end
  end
end
