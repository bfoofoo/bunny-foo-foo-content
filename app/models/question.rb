class Question < ApplicationRecord
  acts_as_paranoid
  audited only: [:position, :is_last]

  belongs_to :formsite, optional: true
  belongs_to :leadgen_rev_site, optional: true

  has_many :answers, dependent: :destroy
  has_many :formsite_questions
  # has_many :formsite, :through => :formsite_questions

  has_many :formsite_user_answers

  accepts_nested_attributes_for :answers, allow_destroy: true
  accepts_nested_attributes_for :formsite_questions, allow_destroy: true

  validates :text, presence: true

  as_enum :flow, [:vertical, :horizontal, :grid, :date, :select, :number], source: :flow, map: :string
  
  scope :order_by_id, -> () { order(id: :asc) }
  scope :order_by_position, -> (position=:asc) { order(position: position) }

  default_scope {order_by_position}

  def mark_as_last!
    update!(is_last: true)
  end
end
