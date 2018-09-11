class AddIsPhoneNumberToFormsites < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :is_phone_number, :boolean, default: false
  end
end
