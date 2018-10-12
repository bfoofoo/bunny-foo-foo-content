class Answer < ApplicationRecord
  S1_HARDCODED="opu17"
  
  acts_as_paranoid

  belongs_to :question, optional: true
  belongs_to :formsite_user, optional: true

  has_many :formsite_user_answers

  validates :text, presence: true

  scope :order_by_id, -> () { order(id: :asc) }
  scope :order_by_question_id, -> () { order(question_id: :asc) }

  default_scope {order(id: :asc)}

  before_save :handle_s1_for_openposition

  def handle_s1_for_openposition
    if self.question.formsite.name == Formsite::OPENPOSITION_NAME && self.redirect_url_changed?
      url, params = self.redirect_url.split("?")
      parsed_params = Rack::Utils.parse_nested_query(params)
      if parsed_params["s1"] != nil
        parsed_params["s1"] = S1_HARDCODED
        self.redirect_url = "#{url}?#{parsed_params.to_query}"
      end
    end
  end
end
