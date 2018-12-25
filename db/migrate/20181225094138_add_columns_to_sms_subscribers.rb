class AddColumnsToSmsSubscribers < ActiveRecord::Migration[5.0]
  def change
    add_reference :sms_subscribers, :cep_rule
    add_column :sms_subscribers, :params, :hstore
  end
end
