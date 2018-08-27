ActiveAdmin.register EmailMarketerMapping, as: 'Email Marketer Mappings' do
  menu parent: 'Email Marketers'

  permit_params :start_date, :source_id, :source_type, :destination_id, :destination_type

  index do
    column :id
    column :source_type
    column :source
    column :destination_type
    column :destination
    column :start_date
    column :last_transfer_at

    actions
  end

  # TODO rework polymorphic associations
  form do |f|
    source_lists = AweberList.all
    destination_lists = MaropostList.all
    f.inputs 'Email Marketer Mapping' do
      f.input :source_type, input_html: { value: 'AweberList' }, as: :hidden
      f.input :source, as: :select, collection: source_lists
      f.input :destination_type, input_html: { value: 'MaropostList' }, as: :hidden
      f.input :destination, as: :select, collection: destination_lists
      f.input :start_date
    end
    f.actions
  end
end
