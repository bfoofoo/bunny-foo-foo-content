class AddLabelToMessageTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :message_templates, :label, :string
  end
end
