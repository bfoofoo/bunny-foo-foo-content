ActiveAdmin.register Category do
  permit_params :name, :description, :slug, website_ids: [], formsite_ids: [], leadgen_rev_site_ids: []


  form do |f|
    f.inputs 'Category' do
      f.input :name
      f.input :description
      f.input :slug
      f.input :websites, :as => :select, :input_html => {:multiple => true}
      f.input :formsites, :as => :select, :input_html => {:multiple => true}
      f.input :leadgen_rev_sites, :as => :select, :input_html => {:multiple => true}
    end
    f.actions
  end
end
