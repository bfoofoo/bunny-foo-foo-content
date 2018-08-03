class FormsiteUserAnswerSerializer < ActiveModel::Serializer
  attributes :id, :formsite_id, :question_id, :answer_id, :formsite_user_id
end
