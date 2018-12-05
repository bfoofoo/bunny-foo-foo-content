class AddFraudUserRedirectUrlToFormsite < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :fraud_user_redirect_url, :string
  end
end
