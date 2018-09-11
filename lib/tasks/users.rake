namespace :users do
  desc 'Create aweber list users from existing users'
  task create_aweber_list_users: :environment do
    users =
      User
        .select('users.id, aweber_lists.id AS aweber_list_id')
        .joins(formsite_users: { formsite: :aweber_lists})
        .where(added_to_aweber: true)
    users.map do |u|
      AweberListUser.find_or_create_by({
        user_id: u.id,
        list_type: 'AweberList',
        list_id: u.aweber_list_id
      })
    end
  end
end
