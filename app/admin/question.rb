ActiveAdmin.register Question do
  permit_params :id, :text, :link_url,
                answer_ids: [],
                answers_attributes: [:id, :text, :is_correct, :question_id, :_create, :_destroy, :question]

  controller do
    def create
      super do |format|
        return if !resource[:text].present?
        return if !resource[:link_url].present?

        questionForm = {
          text: resource[:text],
          link_url: resource[:link_url]
        }

        question = Question.new(questionForm)
        if question.save
          question.answers.push(resource.answers)
        end
      end
    end
  end

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
