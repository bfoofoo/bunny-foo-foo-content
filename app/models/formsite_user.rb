class FormsiteUser < ApplicationRecord
  belongs_to :formsite
  belongs_to :user

  delegate :email, to: :user, allow_nil: true
end
