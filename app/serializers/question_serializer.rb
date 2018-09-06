class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :text, :position, :flow, :input_type
  has_many :answers
end
