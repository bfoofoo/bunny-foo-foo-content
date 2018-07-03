class FormsiteUser < ApplicationRecord
  belongs_to :formsite
  belongs_to :user
end
