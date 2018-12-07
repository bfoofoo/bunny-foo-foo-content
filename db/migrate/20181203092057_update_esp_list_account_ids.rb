class UpdateEspListAccountIds < ActiveRecord::Migration[5.0]
  def up
    ActiveRecord::Base.connection.execute <<~SQL
      UPDATE esp_lists 
      SET account_id = result.new_id 
      FROM (
        SELECT ea.id AS new_id, oa.id AS old_id, 'AdopiaList' AS type 
        FROM esp_accounts ea 
        INNER JOIN adopia_accounts oa ON oa.api_key = ea.api_key 
        WHERE ea.type = 'AdopiaAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'AweberList' AS type 
        FROM esp_accounts ea 
        INNER JOIN aweber_accounts oa ON oa.account_id = ea.account_id 
        WHERE ea.type = 'AweberAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'EliteGroup' AS type 
        FROM esp_accounts ea 
        INNER JOIN elite_accounts oa ON oa.api_key = ea.api_key 
        WHERE ea.type = 'EliteAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'MailgunList' AS type 
        FROM esp_accounts ea 
        INNER JOIN mailgun_accounts oa ON oa.api_key = ea.api_key 
        WHERE ea.type = 'MailgunAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'MaropostList' AS type 
        FROM esp_accounts ea 
        INNER JOIN maropost_accounts oa ON oa.account_id = ea.account_id
        WHERE ea.type = 'MaropostAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'NetatlanticList' AS type 
        FROM esp_accounts ea 
        INNER JOIN netatlantic_accounts oa ON oa.account_name = ea.name 
        WHERE ea.type = 'NetatlanticAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'OnepointList' AS type 
        FROM esp_accounts ea 
        INNER JOIN onepoint_accounts oa ON oa.api_key = ea.api_key 
        WHERE ea.type = 'OnepointAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'OngageList' AS type 
        FROM esp_accounts ea 
        INNER JOIN ongage_accounts oa ON oa.username = ea.username 
        WHERE ea.type = 'OngageAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'SparkpostList' AS type 
        FROM esp_accounts ea 
        INNER JOIN sparkpost_accounts oa ON oa.api_key = ea.api_key 
        WHERE ea.type = 'SparkpostAccount'
      ) AS result
      WHERE result.type = esp_lists.type AND result.old_id = esp_lists.account_id;
    SQL
  end

  def down
    ActiveRecord::Base.connection.execute <<~SQL
      UPDATE esp_lists 
      SET account_id = result.old_id 
      FROM (
        SELECT ea.id AS new_id, oa.id AS old_id, 'AdopiaList' AS type 
        FROM esp_accounts ea 
        INNER JOIN adopia_accounts oa ON oa.api_key = ea.api_key 
        WHERE ea.type = 'AdopiaAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'AweberList' AS type 
        FROM esp_accounts ea 
        INNER JOIN aweber_accounts oa ON oa.account_id = ea.account_id 
        WHERE ea.type = 'AweberAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'EliteGroup' AS type 
        FROM esp_accounts ea 
        INNER JOIN elite_accounts oa ON oa.api_key = ea.api_key 
        WHERE ea.type = 'EliteAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'MailgunList' AS type 
        FROM esp_accounts ea 
        INNER JOIN mailgun_accounts oa ON oa.api_key = ea.api_key 
        WHERE ea.type = 'MailgunAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'MaropostList' AS type 
        FROM esp_accounts ea 
        INNER JOIN maropost_accounts oa ON oa.account_id = ea.account_id
        WHERE ea.type = 'MaropostAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'NetatlanticList' AS type 
        FROM esp_accounts ea 
        INNER JOIN netatlantic_accounts oa ON oa.account_name = ea.name 
        WHERE ea.type = 'NetatlanticAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'OnepointList' AS type 
        FROM esp_accounts ea 
        INNER JOIN onepoint_accounts oa ON oa.api_key = ea.api_key 
        WHERE ea.type = 'OnepointAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'OngageList' AS type 
        FROM esp_accounts ea 
        INNER JOIN ongage_accounts oa ON oa.username = ea.username 
        WHERE ea.type = 'OngageAccount'
        UNION
        SELECT ea.id AS new_id, oa.id AS old_id, 'SparkpostList' AS type 
        FROM esp_accounts ea 
        INNER JOIN sparkpost_accounts oa ON oa.api_key = ea.api_key 
        WHERE ea.type = 'SparkpostAccount'
      ) AS result
      WHERE result.type = esp_lists.type AND result.new_id = esp_lists.account_id;
    SQL
  end
end
