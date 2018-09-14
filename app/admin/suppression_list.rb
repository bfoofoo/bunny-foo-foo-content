ActiveAdmin.register SuppressionList do
  permit_params :file


  index do
    column :id
    column :created_at
    column "file name" do |list|
      list.file.file.filename
    end
    actions
  end

  form do |f|
    f.inputs 'Suppression List' do
      f.input :file
    end
    f.actions
  end
end
