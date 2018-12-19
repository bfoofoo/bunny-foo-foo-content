class AddColumnsToMessageAutoResponses < ActiveRecord::Migration[5.0]
  def change
    add_column :message_auto_responses, :followup, :boolean, default: false
    add_column :message_auto_responses, :event, :string
  end
end
