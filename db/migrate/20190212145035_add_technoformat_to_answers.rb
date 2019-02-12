class AddTechnoformatToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :technoformat, :boolean, default: false
  end
end
