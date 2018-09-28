ActiveAdmin.register ApiClientMapping do
  menu parent: 'Api Clients'

  config.filters = false

  index do
    column :id
    column :source
    column :destination
    column :created_at
    column :updated_at

    actions
  end

  form do |f|
    source_lists = ApiClient.all
    destination_lists = AweberList.all
    f.inputs 'Email Marketer Mapping' do
      f.input :source_type, input_html: { value: 'ApiClient' }, as: :hidden
      f.input :source, as: :select, collection: source_lists
      f.input :destination_type, input_html: { value: 'AweberList' }, as: :hidden
      f.input :destination, as: :select, collection: destination_lists
    end

    f.actions
  end
end
