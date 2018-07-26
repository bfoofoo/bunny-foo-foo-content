class AddMetricsFieldsToFormsite < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :pixel_id, :string
    add_column :formsites, :one_signal_id, :string
  end
end
