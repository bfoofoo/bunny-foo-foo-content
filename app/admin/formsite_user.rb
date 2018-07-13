ActiveAdmin.register FormsiteUser do
  index do |poll|
    id_column
    column :formsite
    column :user
    column :is_verified
  end

end
