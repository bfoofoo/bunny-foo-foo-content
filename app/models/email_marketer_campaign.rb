class EmailMarketerCampaign < ApplicationRecord
  has_many :leads, foreign_key: :campaign_id, dependent: :restrict_with_error

  %w(Aweber Maropost).each do |origin|
    define_singleton_method :"from_#{origin.downcase}" do
      where(origin: origin)
    end
  end

  scope :sent, -> { where.not(sent_at: nil) }

  validates :delay_in_hours, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
end
