ActiveAdmin.register User do
  actions :index

  config.filters = false

  scope :all, default: true
  scope :unsubscribed

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
