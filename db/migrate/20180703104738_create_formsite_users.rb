class CreateFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :formsite_users do |t|
      t.integer :formsite_id
      t.integer :user_id
      t.boolean :is_verified

      t.timestamps
    end
  end
end
