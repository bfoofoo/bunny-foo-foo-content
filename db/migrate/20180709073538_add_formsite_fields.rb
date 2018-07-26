class AddFormsiteFields < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :first_redirect_url, :string
    add_column :formsites, :final_redirect_url, :string
  end
end
