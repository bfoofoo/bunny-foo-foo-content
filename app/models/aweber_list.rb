class AweberList < ApplicationRecord
  belongs_to :aweber_account
  has_many :list_users, class_name: 'AweberListUser', foreign_key: :list_id
  has_many :users, through: :list_users
  has_many :openers, class_name: 'AweberOpener', foreign_key: :source_list_id

  def full_name
    return self.name if self.aweber_account.name.blank?
    "#{self.aweber_account.name} - #{self.name}"
  end
end
