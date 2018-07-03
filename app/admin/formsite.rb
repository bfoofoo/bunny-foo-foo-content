ActiveAdmin.register Formsite do
  permit_params :name, :description, :url, :droplet_id, :droplet_ip, :zone_id, question_ids: []

  index do
    column :id
    column :name
    column :description
    column :droplet_id
    column :droplet_ip
    column :zone_id
    column :created_at
  end

  form do |f|
    f.inputs 'Formsite' do
      f.input :name
      f.input :description
      f.input :questions, as: :check_boxes, :collection => Question.all.map{ |q|  [q.text, q.id] }
    end
    f.actions
  end

  # TODO change website to formsite
  action_item :setup, :only => :show do
    link_to setup_api_v1_websites_path(formsite), class: 'button', remote: true do
      'Setup Formsite'
    end
  end

  action_item :rebuild, :only => :show do
    link_to build_api_v1_websites_path(formsite), class: 'button', remote: true do
      'Rebuild Formsite'
    end
  end
end
