class Answer < ApplicationRecord
  belongs_to :question, optional: true
  belongs_to :formsite_user, optional: true

  validates :text, presence: true

  scope :order_by_id, -> () { order(id: :asc) }
  scope :order_by_question_id, -> () { order(question_id: :asc) }
end
