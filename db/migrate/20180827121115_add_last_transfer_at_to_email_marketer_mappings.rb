class AddLastTransferAtToEmailMarketerMappings < ActiveRecord::Migration[5.0]
  def change
    add_column :email_marketer_mappings, :last_transfer_at, :datetime
  end
end
