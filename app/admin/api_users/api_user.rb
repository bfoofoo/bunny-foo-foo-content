ActiveAdmin.register ApiUser do
  menu parent: "API Users"
  permit_params :email, :first_name, :last_name, :is_verified, :is_useragent_valid, :is_impressionwise_test_success, :is_duplicate, :s1, :s2, :s3, :s4, :s5, :website, :api_client_id, :ip, :captured, :lead_id, :zip, :state, :phone1, :job

  scope :all, :default => true
  scope :verified do
    ApiUser.where("is_verified = ?", true)
  end
  scope :is_useragent_valid do
    ApiUser.where("is_useragent_valid = ?", true)
  end
  scope :is_impressionwise_test_success do
    ApiUser.where("is_impressionwise_test_success = ?", true)
  end
  scope :is_duplicate do
    ApiUser.where("is_duplicate = ?", true)
  end

  index do
    id_column
    resource_class.content_columns.each { |col| column col.name.to_sym }
    column :sent_to_aweber?
    column :sent_to_adopia?
    column :sent_to_elite?
    column :sent_to_ongage?
    actions
  end

  show do
    attributes_table do
      default_attribute_table_rows.each do |field|
        row field
      end

      row :sent_to_aweber?
      row :sent_to_adopia?
      row :sent_to_elite?
      row :sent_to_ongage?
    end
    active_admin_comments
  end
end
