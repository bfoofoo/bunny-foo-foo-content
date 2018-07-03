class Formsite < ApplicationRecord
  has_many :formsite_questions
  has_many :questions, :through => :formsite_questions

  has_many :formsite_users
  has_many :users, :through => :formsite_users do
    def verified
      where("formsite_users.is_verified= ?", true)
    end

    def unverified
      where("formsite_users.is_verified= ?", false)
    end
  end

  accepts_nested_attributes_for :formsite_users, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :users, reject_if: :all_blank, allow_destroy: true

  # accepts_nested_attributes_for :formsite_questions, reject_if: :all_blank, allow_destroy: true
  # accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true
end
