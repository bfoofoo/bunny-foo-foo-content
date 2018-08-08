class AddOauthTokenToAweberAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :aweber_accounts, :oauth_token, :string
  end
end
