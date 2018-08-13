ActiveAdmin.register AweberRule do
  menu parent: "Aweber Accounts"

  permit_params :list_to_id, :list_from_id, :time

  index do
    column :id
    column "List From" do |rule|
      "#{rule.list_from.aweber_account.name} - #{rule.list_from.name}"
    end
    column "List To" do |rule|
      "#{rule.list_to.aweber_account.name} - #{rule.list_to.name}"
    end
    
    column :time
    column :created_at
    actions
  end

  form do |f|
    lists = AweberList.all.map{|list| ["#{list.aweber_account.name}-#{list.name}", list.id]}
    f.inputs 'Aweber Rule' do
      f.input :list_from, :as => :select, :collection => lists
      f.input :list_to, :as => :select, :collection => lists
      f.input :time
    end
    f.actions
  end

  

  show do
    attributes_table do
      row :id
      row "List From" do |rule|
        "#{rule.list_from.aweber_account.name} - #{rule.list_from.name}"
      end
      row "List To" do |rule|
        "#{rule.list_to.aweber_account.name} - #{rule.list_to.name}"
      end
      row :time
    end
    active_admin_comments
  end
end
