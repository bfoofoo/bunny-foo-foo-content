class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :text, :link_url
  has_many :answers
end
