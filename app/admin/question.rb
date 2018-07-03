ActiveAdmin.register Question do
  permit_params :id, :text, :website_id, :link_url, answers_attributes: [:id, :text, :is_correct]


  form do |f|
    f.inputs 'Question' do
      f.input :text
      f.input :link_url
    end

    f.has_many :answers do |ff|
      ff.input :text
      ff.input :is_correct
    end

    f.actions
  end
end
