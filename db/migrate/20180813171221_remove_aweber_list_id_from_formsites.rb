class RemoveAweberListIdFromFormsites < ActiveRecord::Migration[5.0]
  def change
    remove_column :formsites, :aweber_list_id, :integer
  end
end
