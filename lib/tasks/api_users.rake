namespace :api_users do

  desc 'Refresh Api users is_impressionwise_test'
  task refresh_impressionwise_test: :environment do
    date = "2018-10-24".to_date
    puts "getting not fluent api users"
    ids_map = ApiUser
          .where("created_at >= ?", date)
          .where(is_impressionwise_test_success: false)
          .where.not(api_client_id: [2, 11])
          .in_groups_of(500)
          .map{|users| users.compact.pluck(:id)}


    puts "sending to worker..."
    ids_map.each do |ids| 
      ApiUsers::RefreshImpressionwiseApiUsersWorker.perform_async(ids)
    end
    

    puts "gettting fluent api users..."
    date = "2018-10-18".to_date
    ids_map = ApiUser
      .where("created_at >= ?", date)
      .where(is_impressionwise_test_success: false)
      .where(api_client_id: [2, 11])
      .in_groups_of(500)
      .map{|users| users.compact.pluck(:id)}
    

    puts "sending to worker..."
    ids_map.each do |ids| 
      ApiUsers::RefreshImpressionwiseApiUsersWorker.perform_async(ids)
    end

  end
end
