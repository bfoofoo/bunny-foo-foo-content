ActiveAdmin.register ApiClientMapping do
  permit_params :source_id, :destination_id, :tag

  menu parent: 'Api Clients'

  config.filters = false

  index do
    column :id
    column :source
    column :destination_type
    column :destination
    column('Affiliate') { |a| a.tag }
    column :created_at
    column :updated_at

    actions
  end

  form do |f|
    source_lists = ApiClient.all
    destinations = %w(Aweber Maropost)
    aweber_lists = AweberList.all
    maropost_lists = MaropostList.all

    f.inputs 'Email Marketer Mapping' do
      f.input :source_type, input_html: { value: 'ApiClient' }, as: :hidden
      f.input :source, as: :select, collection: source_lists
      f.input :destination_type, as: :select, collection: destinations
      f.input :destination, as: :select, collection: aweber_lists
      f.input :tag, label: 'Affiliate'
    end

    f.actions
  end

  show do
    attributes_table do
      row :source
      row :destination_type
      row :destination
      row('Affiliate') { |a| a.tag }
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end
end
