ActiveAdmin.register MaropostAccount do
  permit_params :name, :account_id, :auth_token

  index do
    column :id
    column :name
    column :account_id
    column :auth_token
    column "Lists count" do |account|
      account.lists.count
    end

    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :account_id
      row :auth_token
      row :created_at
      panel "Lists" do
        table_for maropost_account.lists do
          column :id
          column 'List ID', :list_id
          column :name
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Maropost Account' do
      f.input :name
      f.input :account_id, label: 'Account ID'
      f.input :auth_token, input_html: { rows: 2 }
    end

    f.actions
  end
end
