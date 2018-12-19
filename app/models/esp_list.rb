class EspList < ApplicationRecord
  has_many :message_auto_responses, as: :esp_list, dependent: :nullify

  before_destroy :purge_associations

  delegate :sending_limit, to: :account

  def id_with_type
    "#{model_name.name}_#{self.id}"
  end

  def full_name
    return name if account.display_name.blank?
    "#{account.display_name} - #{name}"
  end
  
  # TODO resolve this to work in association
  def exported_leads
    ExportedLead.where(list_type: type, list_id: id).count
  end
  
  # Workaround to delete esp rules lists
  # TODO resolve this to work in rails way
  def purge_associations
    EspRulesList.where(list_type: type, list_id: id).delete_all
    ExportedLead.where(list_type: type, list_id: id).delete_all
    MessageAutoResponse.where(esp_list_type: type, esp_list_id: id).delete_all
  end

  def self.provider
    self.model_name.name.underscore.split('_').first
  end
end
