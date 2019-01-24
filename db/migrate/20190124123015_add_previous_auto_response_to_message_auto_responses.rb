class AddPreviousAutoResponseToMessageAutoResponses < ActiveRecord::Migration[5.0]
  def change
    add_column :message_auto_responses, :previous_auto_response_id, :integer
  end
end
