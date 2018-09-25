class MakeEmailMarketerListUsersPolymorphic < ActiveRecord::Migration[5.0]
  def up
    add_reference :email_marketer_list_users, :linkable, polymorphic: true, index: { name: 'index_email_marketer_list_users_to_linkable' }

    ActiveRecord::Base.connection.execute <<~SQL
      UPDATE email_marketer_list_users
      SET linkable_id = user_id, linkable_type = 'User'
    SQL

    remove_reference :email_marketer_list_users, :user, foreign_key: true
  end

  def down
    remove_reference :email_marketer_list_users, :linkable, polymorphic: true

    ActiveRecord::Base.connection.execute <<~SQL
      UPDATE email_marketer_list_users
      SET user_id = linkable_id
    SQL

    add_reference :email_marketer_list_users, :user, foreign_key: true
  end
end
