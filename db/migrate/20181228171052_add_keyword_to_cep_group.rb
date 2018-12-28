class AddKeywordToCepGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :cep_groups, :keyword, :string
  end
end
