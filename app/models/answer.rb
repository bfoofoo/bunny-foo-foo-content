class Answer < ApplicationRecord
  acts_as_paranoid

  belongs_to :question, optional: true
  belongs_to :formsite_user, optional: true

  has_many :formsite_user_answers

  validates :text, presence: true

  scope :order_by_id, -> () { order(id: :asc) }
  scope :order_by_question_id, -> () { order(question_id: :asc) }

  default_scope {order(id: :asc)}
end
