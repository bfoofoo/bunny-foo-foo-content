class EspList < ApplicationRecord
  has_many :exported_leads, as: :list

  before_destroy :purge_esp_rules_lists

  delegate :sending_limit, to: :account

  def id_with_type
    "#{model_name.name}_#{self.id}"
  end

  def full_name
    return name if account.display_name.blank?
    "#{account.display_name} - #{name}"
  end

  # Workaround to delete esp rules lists
  # TODO resolve this to work in rails way
  def purge_esp_rules_lists
    EspRulesList.where(list_type: type, list_id: id).delete_all
  end

  def self.provider
    self.model_name.name.underscore.split('_').first
  end
end
