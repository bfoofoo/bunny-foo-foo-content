class FormsiteUser < ApplicationRecord
  belongs_to :formsite
  belongs_to :user

  delegate :email, to: :user, allow_nil: true

  scope :by_s_filter, -> (s_field) { 
    where.not("#{s_field}" => nil)
    .where.not("#{s_field}" => "")
  }

end
