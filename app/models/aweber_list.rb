class AweberList < ApplicationRecord
  belongs_to :aweber_account

  def full_name
    return self.name if self.aweber_account.name.blank?
    "#{self.aweber_account.name} - #{self.name}"
  end
end
