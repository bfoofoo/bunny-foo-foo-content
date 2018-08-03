class FormsiteUserAnswer < ApplicationRecord
  belongs_to :formsite_user, optional: true
  belongs_to :formsite, optional: true
  belongs_to :question, optional: true
end
