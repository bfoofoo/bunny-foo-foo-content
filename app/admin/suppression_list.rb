ActiveAdmin.register SuppresionList do
  permit_params :file


  index do
    column :id
    column :created_at
  end

  form do |f|
    f.inputs 'Suppression List' do
      f.input :file
    end
    f.actions
  end
end
