class CreateEmailMarketerListUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :email_marketer_list_users do |t|
      t.references :list, polymorphic: true
      t.references :user, index: true, foreign_key: true
    end
  end
end
