class AddRedirectUrlToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :redirect_url, :string
  end
end
