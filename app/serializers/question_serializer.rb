class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :text, :position, :flow, :answers
  
  def answers
    object.answers
  end
end
