class Answer < ApplicationRecord
  S1_HARDCODED="opu17"
  
  acts_as_paranoid

  belongs_to :question, optional: true
  belongs_to :formsite_user, optional: true

  has_many :formsite_user_answers
  has_many :leadgen_rev_site_user_answers
  has_many :prelander_site_user_answers

  validates :text, presence: true

  scope :order_by_id, -> () { order(id: :asc) }
  scope :order_by_question_id, -> () { order(question_id: :asc) }
  scope :of_formsites, -> { joins(:question).where.not(questions: { formsite_id: nil }) }
  scope :of_leadgen_rev_sites, -> { joins(:question).where.not(questions: { leadgen_rev_site_id: nil }) }

  default_scope {order(id: :asc)}

  before_save :handle_s1_for_openposition

  def handle_s1_for_openposition
    object = self.question.try(:formsite) || self.question.try(:leadgen_rev_site)
    return unless object
    if object.name == object.class::OPENPOSITION_NAME && self.redirect_url_changed?
      url, params = self.redirect_url.split("?")
      parsed_params = Rack::Utils.parse_nested_query(params)
      if parsed_params["s1"] != nil
        parsed_params["s1"] = S1_HARDCODED
        self.redirect_url = "#{url}?#{parsed_params.to_query}"
      end
    end
  end
end
