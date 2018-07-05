class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :formsite_questions
  has_many :formsite, :through => :formsite_questions

  accepts_nested_attributes_for :answers, allow_destroy: true
  accepts_nested_attributes_for :formsite_questions, allow_destroy: true
end
