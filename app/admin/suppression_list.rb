ActiveAdmin.register SuppressionList do
  permit_params :file, :autoremove_from_esp,
                suppression_aweber_lists_attributes: [:id, :_destroy, :removable_type, :removable_id],
                suppression_maropost_lists_attributes: [:id, :_destroy, :removable_type, :removable_id]

  index do
    column :id
    column :created_at
    column "file name" do |list|
      list.file.file.filename
    end
    column 'Autoremove from ESP', :autoremove_from_esp
    actions
  end

  filter :created_at
  filter :updated_at
  filter :autoremove_from_esp

  show do
    attributes_table do
      default_attribute_table_rows.each do |field|
        row field
      end

      row 'Aweber Lists' do |suppression_list|
        suppression_list.aweber_lists.map(&:full_name).join(',')
      end

      row 'Maropost Lists' do |suppression_list|
        suppression_list.maropost_lists.map(&:full_name).join(',')
      end
    end

    active_admin_comments
  end

  form do |f|
    f.inputs 'Deletion List' do
      f.input :file
      f.input :autoremove_from_esp, label: 'Autoremove from ESP'
    end

    #if f.object.autoremove_from_esp?
      f.inputs 'Aweber lists' do
        f.has_many :suppression_aweber_lists, allow_destroy: true, new_record: true, heading: false do |ff|
          ff.semantic_errors
          ff.input :removable_type, input_html: { value: 'AweberList' }, as: :hidden
          ff.input :removable_id, label: 'List', as: :select, collection: AweberList.all.includes(:aweber_account)
        end
      end

      f.inputs 'Maropost lists' do
        f.has_many :suppression_maropost_lists, allow_destroy: true, new_record: true, heading: false do |ff|
          ff.semantic_errors
          ff.input :removable_type, input_html: { value: 'MaropostList' }, as: :hidden
          ff.input :removable_id, label: 'List', as: :select, collection: MaropostList.all.includes(:maropost_account)
        end
      end
    #end
    f.actions
  end
end
