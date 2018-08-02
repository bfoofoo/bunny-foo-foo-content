class Answer < ApplicationRecord
  belongs_to :question, optional: true
  belongs_to :formsite_user, optional: true

  validates :text, presence: true
end
