class AddCustomFieldValueToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :custom_field_value, :string
  end
end
