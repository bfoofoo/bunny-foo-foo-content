ActiveAdmin.register WebsiteUserAnswer do
    menu parent: 'User answers'
  
    filter :id
    index do
      selectable_column
      id_column
      column :answer_id
      column :question_id
      column "Website" do |answer|
        link_to answer.website.name, admin_website_path(answer.website)
      end
      column "Website User" do |answer|
        if answer.formsite_user && answer.formsite_user.user
          link_to answer.formsite_user.user.email, admin_formsite_user_path(answer.formsite_user)
        end
      end
      actions
    end
  end
  