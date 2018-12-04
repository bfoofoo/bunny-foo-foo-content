class CreateEspSendingLimits < ActiveRecord::Migration[5.0]
  def change
    enable_extension "hstore"
    create_table :esp_sending_limits do |t|
      t.string :provider, null: false
      t.integer :daily_limit, default: 0
      t.hstore :isp_limits

      t.timestamps
    end
    add_index :esp_sending_limits, :isp_limits, using: :gin
  end
end
