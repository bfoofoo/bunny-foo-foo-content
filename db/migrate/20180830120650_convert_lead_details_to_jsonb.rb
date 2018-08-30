class ConvertLeadDetailsToJsonb < ActiveRecord::Migration[5.0]
  def change
    change_column :leads, :details, :jsonb
  end
end
