class MigrateEspAccounts < ActiveRecord::Migration[5.0]
  def up
    ActiveRecord::Base.connection.execute <<~SQL
      INSERT INTO esp_accounts(name, api_key, type, created_at, updated_at) SELECT name, api_key, 'AdopiaAccount', NOW(), NOW() FROM adopia_accounts;
      INSERT INTO esp_accounts(name, account_id, access_token, secret_token, oauth_token, type, created_at, updated_at) SELECT name, account_id, access_token, secret_token, oauth_token, 'AweberAccount', NOW(), NOW() FROM aweber_accounts;
      INSERT INTO esp_accounts(username, api_key, type, created_at, updated_at) SELECT sender, api_key, 'EliteAccount', NOW(), NOW() FROM elite_accounts;
      INSERT INTO esp_accounts(name, api_key, type, created_at, updated_at) SELECT name, api_key, 'MailgunAccount', NOW(), NOW() FROM mailgun_accounts;
      INSERT INTO esp_accounts(name, account_id, access_token, type, created_at, updated_at) SELECT name, account_id, auth_token, 'MaropostAccount', NOW(), NOW() FROM maropost_accounts;
      INSERT INTO esp_accounts(name, username, type, created_at, updated_at) SELECT account_name, sender, 'NetatlanticAccount', NOW(), NOW() FROM netatlantic_accounts;
      INSERT INTO esp_accounts(username, api_key, type, created_at, updated_at) SELECT username, api_key, 'OnepointAccount', NOW(), NOW() FROM onepoint_accounts;
      INSERT INTO esp_accounts(username, password, account_code, type, created_at, updated_at) SELECT username, password, account_code, 'OngageAccount', NOW(), NOW() FROM ongage_accounts;
      INSERT INTO esp_accounts(username, account_id, api_key, type, created_at, updated_at) SELECT username, account_id, api_key, 'SparkpostAccount', NOW(), NOW() FROM sparkpost_accounts;
    SQL
  end

  def down
    ActiveRecord::Base.connection.execute <<~SQL
      INSERT INTO adopia_accounts(name, api_key, created_at, updated_at) SELECT name, api_key, NOW(), NOW() FROM esp_accounts WHERE type = 'AdopiaAccount';
      INSERT INTO aweber_accounts(name, account_id, access_token, secret_token, oauth_token, created_at, updated_at) SELECT name, account_id, access_token, secret_token, oauth_token, NOW(), NOW() FROM esp_accounts WHERE type = 'AweberAccount';
      INSERT INTO elite_accounts(sender, api_key, created_at, updated_at) SELECT username, api_key, NOW(), NOW() FROM esp_accounts WHERE type = 'EliteAccount';
      INSERT INTO mailgun_accounts(name, api_key, created_at, updated_at) SELECT name, api_key, NOW() NOW() FROM esp_accounts WHERE type = 'MailgunAccount';
      INSERT INTO maropost_accounts(name, account_id, auth_token, created_at, updated_at) SELECT name, account_id, access_token,  NOW(), NOW() FROM esp_accounts WHERE type = 'MaropostAccount';
      INSERT INTO netatlantic_accounts(account_name, sender, created_at, updated_at) SELECT name, username, NOW(), NOW() FROM esp_accounts WHERE type = 'NetatlanticAccount';
      INSERT INTO onepoint_accounts(username, api_key, created_at, updated_at) SELECT username, api_key, NOW(), NOW() FROM esp_accounts WHERE type = 'OnepointAccount';
      INSERT INTO ongage_accounts(username, password, account_code, created_at, updated_at) SELECT username, password, account_code NOW(), NOW() FROM esp_accounts WHERE type = 'OngageAccount';
      INSERT INTO sparkpost_accounts(username, account_id, api_key, created_at, updated_at) SELECT username, account_id, api_key, NOW(), NOW() FROM esp_accounts WHERE type = 'SparkpostAccount';
    SQL
  end
end
