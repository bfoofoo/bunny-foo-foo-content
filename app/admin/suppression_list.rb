ActiveAdmin.register SuppressionList do
  permit_params :file, :autoremove_from_esp


  index do
    column :id
    column :created_at
    column "file name" do |list|
      list.file.file.filename
    end
    column 'Autoremove from ESP', :autoremove_from_esp
    actions
  end

  form do |f|
    f.inputs 'Suppression List' do
      f.input :file
      f.input :autoremove_from_esp, label: 'Autoremove from ESP'
    end
    f.actions
  end
end
