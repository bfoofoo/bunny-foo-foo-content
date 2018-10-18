ActiveAdmin.register User, as: "Unsubscribed Users" do
  actions :index

  config.filters = false

  controller do
    def scoped_collection
      User.unsubscribed
    end
  end

  index do |user|
    selectable_column
    id_column
    column :created_at
    column :updated_at
    column :first_name
    column :last_name
    column :email
  end
end
