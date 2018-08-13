ActiveAdmin.register AweberRule do
  menu parent: "Aweber Accounts"

  permit_params :list_to_id, :list_from_id, :time

  index do
    column :id
    column "List From" do |rule|
      rule.list_from.full_name
    end
    column "List To" do |rule|
      rule.list_to.full_name
    end
    
    column "Time in days" do |rule|
      rule.time
    end
    
    column :created_at
    actions
  end

  form do |f|
    lists = AweberList.all.map{|list| [list.full_name, list.id]}
    f.inputs 'Aweber Rule' do
      f.input :list_from, :as => :select, :collection => lists
      f.input :list_to, :as => :select, :collection => lists
      f.input :time, :label => 'Time in days'
    end
    f.actions
  end

  

  show do
    attributes_table do
      row :id
      row "List From" do |rule|
        rule.list_from.full_name
      end
      row "List To" do |rule|
        rule.list_to.full_name
      end

      row "Time in days" do |rule|
        rule.time
      end
    end
    active_admin_comments
  end
end
