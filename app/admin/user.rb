ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email

  index do |user|
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email

    column "Forms" do |user|
      span user.formsites.map(&:name)
    end

    column :expiration_date
    actions
  end


  form do |f|
    f.inputs 'User' do
      f.input :first_name
      f.input :last_name
      f.input :email
      # TODO add formsites
    end
    f.actions
  end
end
