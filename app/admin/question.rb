ActiveAdmin.register Question do
  permit_params :id, :text, answer_ids: [],
                answers_attributes: [:id, :text, :redirect_url, :question_id, :_create, :_destroy, :question]

  form do |f|
    f.semantic_errors
    f.inputs 'Question' do
      f.input :text
    end
    f.inputs do
      f.has_many :answers, allow_destroy: true, new_record: true do |ff|
        ff.semantic_errors
        ff.input :text
        ff.input :redirect_url
      end
    end

    f.actions
  end
end
