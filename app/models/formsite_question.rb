class FormsiteQuestion < ApplicationRecord
  belongs_to :formsite, optional: true
  belongs_to :question
end
