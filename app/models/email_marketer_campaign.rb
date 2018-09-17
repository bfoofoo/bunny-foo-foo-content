class EmailMarketerCampaign < ApplicationRecord
  has_many :leads, foreign_key: :campaign_id, dependent: :restrict_with_error

  %w(Aweber Maropost).each do |origin|
    define_singleton_method :"from_#{origin.downcase}" do
      where(origin: origin)
    end
  end

  scope :sent, -> { where.not(sent_at: nil) }
end
