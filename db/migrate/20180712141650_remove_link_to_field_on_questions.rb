class RemoveLinkToFieldOnQuestions < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :link_url, :string
  end
end
