ActiveAdmin.register ApiClientMapping do
  permit_params :source_id, :destination_id, :destination_type, :tag

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
    destinations = %w(AweberList MaropostList)
    aweber_lists = AweberList.all
    maropost_lists = MaropostList.all

    f.inputs 'Email Marketer Mapping' do
      f.input :source_type, input_html: { value: 'ApiClient' }, as: :hidden
      f.input :source, as: :select, collection: source_lists
      f.input :destination_type, as: :select, collection: destinations, input_html: { id: 'destination_type', required: 'true' }
      f.input :destination_id, as: :select, collection: aweber_lists, wrapper_html: { id: 'aweber_selector' }
      f.input :destination_id, as: :select, collection:  maropost_lists, wrapper_html: { id: 'maropost_selector' }
      f.input :tag, label: 'Affiliate'
    end

    f.actions

    script do
      raw "$(document).ready(function () {
        $('#destination_type').on('change', function () {
          var value = $(this).val();
          var $aweber = $('#aweber_selector');
          var $maropost = $('#maropost_selector');

          $aweber.hide();
          $aweber.find('select').attr('disabled', true);
          $maropost.hide();
          $maropost.find('select').attr('disabled', true);

          switch (value) {
            case 'MaropostList': {
              $maropost.show();
              $maropost.find('select').removeAttr('disabled');
              break;
            }
            case 'AweberList': {
              $aweber.show();
              $aweber.find('select').removeAttr('disabled');
              break;
            }
          }
        });

        $('#destination_type').trigger('change');
      });"
    end
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
