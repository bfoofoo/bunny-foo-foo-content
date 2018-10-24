ActiveAdmin.register LeadgenRevSiteUserAnswer do
  menu parent: 'User answers'

  filter :id
  index do
    selectable_column
    id_column
    column :answer_id
    column :question_id
    column "LeadgenRevSite" do |answer|
      link_to answer.leadgen_rev_site.name, admin_leadgen_rev_site_path(answer.leadgen_rev_site)
    end
    column "LeadgenRevSite User" do |answer|
      if answer.leadgen_rev_site_user && answer.leadgen_rev_site_user.user
        link_to answer.leadgen_rev_site_user.user.email, admin_leadgen_rev_site_user_path(answer.leadgen_rev_site_user)
      end
    end
    actions
  end
end
