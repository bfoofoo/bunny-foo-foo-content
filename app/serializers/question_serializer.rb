class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :text
  has_many :answers
end
