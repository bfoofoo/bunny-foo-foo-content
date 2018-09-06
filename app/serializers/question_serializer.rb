class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :text, :position, :flow
  has_many :answers
end
