class MigrateEspLists < ActiveRecord::Migration[5.0]
  def up
    ActiveRecord::Base.connection.execute <<~SQL
      INSERT INTO esp_lists(account_id, list_id, name, type, created_at, updated_at) SELECT adopia_account_id, list_id, name, 'AdopiaList', NOW(), NOW() FROM adopia_lists;
      INSERT INTO esp_lists(account_id, list_id, name, type, created_at, updated_at) SELECT aweber_account_id, list_id, name, 'AweberList', NOW(), NOW() FROM aweber_lists;
      INSERT INTO esp_lists(account_id, slug, name, type, created_at, updated_at) SELECT elite_account_id, group_id, name, 'EliteGroup', NOW(), NOW() FROM elite_groups;
      INSERT INTO esp_lists(account_id, address, name, type, created_at, updated_at) SELECT mailgun_account_id, address, name, 'MailgunList', NOW(), NOW() FROM mailgun_lists;
      INSERT INTO esp_lists(account_id, list_id, name, type, created_at, updated_at) SELECT maropost_account_id, list_id, name, 'MaropostList', NOW(), NOW() FROM maropost_lists;
      INSERT INTO esp_lists(account_id, list_id, name, type, created_at, updated_at) SELECT netatlantic_account_id, list_id, name, 'NetatlanticList', NOW(), NOW() FROM netatlantic_lists;
      INSERT INTO esp_lists(account_id, list_id, name, type, created_at, updated_at) SELECT onepoint_account_id, list_id, name, 'OnepointList', NOW(), NOW() FROM onepoint_lists;
      INSERT INTO esp_lists(account_id, list_id, name, type, created_at, updated_at) SELECT ongage_account_id, list_id, name, 'OngageList', NOW(), NOW() FROM ongage_lists;
      INSERT INTO esp_lists(account_id, slug, name, type, created_at, updated_at) SELECT sparkpost_account_id, list_id, name, '', NOW(), NOW() FROM sparkpost_lists;

      UPDATE esp_rules_lists
      SET list_id = result.new_id
      FROM (
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN adopia_lists ol ON el.list_id = ol.list_id WHERE el.type = 'AdopiaList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN aweber_lists ol ON el.list_id = ol.list_id WHERE el.type = 'AweberList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN elite_groups ol ON el.slug = ol.group_id WHERE el.type = 'EliteGroup'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN mailgun_lists ol ON el.address = ol.address WHERE el.type = 'MailgunList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN maropost_lists ol ON el.list_id = ol.list_id WHERE el.type = 'MaropostList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN netatlantic_lists ol ON el.list_id = ol.list_id WHERE el.type = 'NetatlanticList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN onepoint_lists ol ON el.list_id = ol.list_id WHERE el.type = 'OnepointList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN ongage_lists ol ON el.list_id = ol.list_id WHERE el.type = 'OngageList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN sparkpost_lists ol ON el.slug = ol.list_id WHERE el.type = 'SparkpostList'
      ) AS result
      WHERE result.type = esp_rules_lists.list_type AND result.old_id = esp_rules_lists.list_id;

      UPDATE exported_leads
      SET list_id = result.new_id
      FROM (
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN adopia_lists ol ON el.list_id = ol.list_id WHERE el.type = 'AdopiaList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN aweber_lists ol ON el.list_id = ol.list_id WHERE el.type = 'AweberList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN elite_groups ol ON el.slug = ol.group_id WHERE el.type = 'EliteGroup'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN mailgun_lists ol ON el.address = ol.address WHERE el.type = 'MailgunList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN maropost_lists ol ON el.list_id = ol.list_id WHERE el.type = 'MaropostList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN netatlantic_lists ol ON el.list_id = ol.list_id WHERE el.type = 'NetatlanticList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN onepoint_lists ol ON el.list_id = ol.list_id WHERE el.type = 'OnepointList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN ongage_lists ol ON el.list_id = ol.list_id WHERE el.type = 'OngageList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN sparkpost_lists ol ON el.slug = ol.list_id WHERE el.type = 'SparkpostList'
      ) AS result
      WHERE result.type = exported_leads.list_type AND result.old_id = exported_leads.list_id;
    SQL
  end

  def down
    ActiveRecord::Base.connection.execute <<~SQL
      INSERT INTO adopia_lists(adopia_account_id, list_id, name, type, created_at, updated_at) SELECT adopia_account_id, list_id, name, 'AdopiaList', NOW(), NOW() FROM adopia_lists;
      INSERT INTO aweber_lists(aweber_account_id, list_id, name, type, created_at, updated_at) SELECT aweber_account_id, list_id, name, 'AweberList', NOW(), NOW() FROM aweber_lists;
      INSERT INTO elite_groups(elite_account_id, group_id, name, type, created_at, updated_at) SELECT elite_account_id, slug, name, 'EliteGroup', NOW(), NOW() FROM elite_groups;
      INSERT INTO mailgun_lists(mailgun_account_id, address, name, type, created_at, updated_at) SELECT mailgun_account_id, address, name, 'MailgunList', NOW(), NOW() FROM mailgun_lists;
      INSERT INTO maropost_lists(maropost_account_id, list_id, name, type, created_at, updated_at) SELECT maropost_account_id, list_id, name, 'MaropostList', NOW(), NOW() FROM maropost_lists;
      INSERT INTO netatlantic_lists(netatlantic_account_id, list_id, name, type, created_at, updated_at) SELECT netatlantic_account_id, list_id, name, 'NetatlanticList', NOW(), NOW() FROM netatlantic_lists;
      INSERT INTO onepoint_lists(onepoint_account_id, list_id, name, type, created_at, updated_at) SELECT onepoint_account_id, list_id, name, 'OnepointList', NOW(), NOW() FROM onepoint_lists;
      INSERT INTO ongage_lists(ongage_account_id, list_id, name, type, created_at, updated_at) SELECT ongage_account_id, list_id, name, 'OngageList', NOW(), NOW() FROM ongage_lists;
      INSERT INTO sparkpost_lists(sparkpost_account_id, list_id, name, type, created_at, updated_at) SELECT sparkpost_account_id, slug, name, 'SparkpostList', NOW(), NOW() FROM sparkpost_lists;

      UPDATE exported_leads
      SET list_id = result.old_id
      FROM (
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN adopia_lists ol ON el.list_id = ol.list_id WHERE el.type = 'AdopiaList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN aweber_lists ol ON el.list_id = ol.list_id WHERE el.type = 'AweberList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN elite_groups ol ON el.slug = ol.group_id WHERE el.type = 'EliteGroup'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN mailgun_lists ol ON el.address = ol.address WHERE el.type = 'MailgunList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN maropost_lists ol ON el.list_id = ol.list_id WHERE el.type = 'MaropostList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN netatlantic_lists ol ON el.list_id = ol.list_id WHERE el.type = 'NetatlanticList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN onepoint_lists ol ON el.list_id = ol.list_id WHERE el.type = 'OnepointList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN ongage_lists ol ON el.list_id = ol.list_id WHERE el.type = 'OngageList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN sparkpost_lists ol ON el.slug = ol.list_id WHERE el.type = 'SparkpostList'
      ) AS result
      WHERE result.type = exported_leads.list_type AND result.new_id = exported_leads.list_id;

      UPDATE esp_rules_lists
      SET list_id = result.old_id
      FROM (
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN adopia_lists ol ON el.list_id = ol.list_id WHERE el.type = 'AdopiaList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN aweber_lists ol ON el.list_id = ol.list_id WHERE el.type = 'AweberList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN elite_groups ol ON el.slug = ol.group_id WHERE el.type = 'EliteGroup'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN mailgun_lists ol ON el.address = ol.address WHERE el.type = 'MailgunList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN maropost_lists ol ON el.list_id = ol.list_id WHERE el.type = 'MaropostList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN netatlantic_lists ol ON el.list_id = ol.list_id WHERE el.type = 'NetatlanticList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN onepoint_lists ol ON el.list_id = ol.list_id WHERE el.type = 'OnepointList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN ongage_lists ol ON el.list_id = ol.list_id WHERE el.type = 'OngageList'
        UNION
        SELECT el.id AS new_id, ol.id AS old_id, el.type AS type FROM esp_lists el INNER JOIN sparkpost_lists ol ON el.slug = ol.list_id WHERE el.type = 'SparkpostList'
      ) AS result
      WHERE result.type = esp_rules_lists.list_type AND result.new_id = esp_rules_lists.list_id;
    SQL
  end
end
