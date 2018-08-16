class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :formsite_questions
  has_many :formsite, :through => :formsite_questions

  has_many :formsite_user_answers

  accepts_nested_attributes_for :answers, allow_destroy: true
  accepts_nested_attributes_for :formsite_questions, allow_destroy: true

  validates :text, presence: true

  scope :order_by_id, -> () { order(id: :asc) }
  scope :order_by_position, -> (position=:asc) { order(position: position) }
end
