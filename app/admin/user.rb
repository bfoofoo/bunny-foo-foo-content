ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email

  scope :verified, :default => true do |users|
    formsites = FormsiteUser.where("is_verified = ?", true)
    users = formsites.map(&:user)
    User.where(id: users.map(&:id))
  end

  scope :all

  index do |user|
    selectable_column
    id_column
    column :created_at
    column :updated_at
    column :first_name
    column :last_name
    column :email

    column "Forms" do |user|
      span user.formsites.map(&:name)
    end
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
