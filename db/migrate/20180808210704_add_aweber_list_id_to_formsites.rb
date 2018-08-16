class AddAweberListIdToFormsites < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :aweber_list_id, :integer
  end
end
