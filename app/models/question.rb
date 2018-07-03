class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :formsite_questions
  has_many :formsite, :through => :formsite_questions

  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :formsite_questions, reject_if: :all_blank, allow_destroy: true
end
