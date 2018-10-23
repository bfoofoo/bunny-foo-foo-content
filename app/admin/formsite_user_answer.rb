ActiveAdmin.register FormsiteUserAnswer do
  filter :id
  index do
    selectable_column
    id_column
    column :answer_id
    column :question_id
    column "Formsite" do |answer|
      link_to answer.formsite.name, admin_formsite_path(answer.formsite)
    end
    column "Formsite User" do |answer|
      if answer.formsite_user && answer.formsite_user.user
        link_to answer.formsite_user.user.email, admin_formsite_user_path(answer.formsite_user)
      end
    end
    actions
  end
end
