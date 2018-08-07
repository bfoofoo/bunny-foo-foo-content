class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :text, :position
  has_many :answers
end
