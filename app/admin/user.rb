ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email


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
