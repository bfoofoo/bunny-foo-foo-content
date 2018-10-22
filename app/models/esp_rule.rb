class EspRule < ApplicationRecord
  LIST_TYPES_MAPPING = {
    'Adopia' => 'AdopiaList',
    'Aweber' => 'AweberList',
    'Elite' => 'EliteGroup',
    'Ongage' => 'OngageList'
  }.freeze

  belongs_to :source, polymorphic: true
  has_many :esp_rules_lists, dependent: :destroy

  accepts_nested_attributes_for :esp_rules_lists, allow_destroy: true

  validates :delay_in_hours, numericality: { greater_than_or_equal_to: 0 }
  validates :esp_rules_lists, presence: true

  def split?
    esp_rules_lists.count > 1
  end
end
