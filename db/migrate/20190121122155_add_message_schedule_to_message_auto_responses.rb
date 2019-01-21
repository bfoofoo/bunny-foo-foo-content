class AddMessageScheduleToMessageAutoResponses < ActiveRecord::Migration[5.0]
  def change
    add_reference :message_auto_responses, :message_schedule
  end
end
