class Question < ApplicationRecord
  acts_as_paranoid
  audited only: [:position, :is_last]

  # TODO: refactor to polymorphic?
  belongs_to :formsite, optional: true
  belongs_to :leadgen_rev_site, optional: true
  belongs_to :website, optional: true
  belongs_to :prelander_site, optional: true

  belongs_to :custom_field, optional: true

  has_many :answers, dependent: :destroy
  has_many :formsite_questions
  # has_many :formsite, :through => :formsite_questions

  has_many :formsite_user_answers
  has_many :leadgen_rev_site_user_answers
  has_many :prelander_site_user_answers

  accepts_nested_attributes_for :answers, allow_destroy: true
  accepts_nested_attributes_for :formsite_questions, allow_destroy: true

  validates :text, presence: true
  validates :position, presence: true

  as_enum :flow, [:vertical, :horizontal, :grid, :date, :select, :number], source: :flow, map: :string
  
  scope :for_prelander, -> () { where(for_prelander: true) }
  scope :not_for_prelander, -> () { where(for_prelander: false) }
  scope :order_by_id, -> () { order(id: :asc) }
  scope :order_by_position, -> (position=:asc) { order(position: position) }
  scope :of_formsites, -> { where.not(formsite_id: nil) }
  scope :of_leadgen_rev_sites, -> { where.not(leadgen_rev_site_id: nil) }
  scope :of_prelander_sites, -> { where.not(prelander_site_id: nil) }

  default_scope {order_by_position}

  def mark_as_last!
    update!(is_last: true)
  end
end
