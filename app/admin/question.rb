ActiveAdmin.register Question do
  permit_params :id, :text, :link_url,
                answer_ids: [],
                answers_attributes: [:id, :text, :is_correct, :question_id, :_create, :_destroy, :question]

  form do |f|
    f.semantic_errors
    f.inputs 'Question' do
      f.input :text
      f.input :link_url
    end
    f.inputs do
      f.has_many :answers, allow_destroy: true, new_record: true do |ff|
        ff.semantic_errors
        ff.input :text
        ff.input :is_correct
      end
    end

    f.actions
  end
end
