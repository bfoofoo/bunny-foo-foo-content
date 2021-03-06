module WebsiteUsers
    class SendToEspWorker
      include Sidekiq::Worker
      include Concerns::EspWorker
  
      def perform
        rules.each do |rule|
          website_users = available_website_users_for(rule)
          website_users = website_users.where('users.email ~* ?', '@' + rule.domain + '\.\w+$') if rule.domain.present?
          filtered_esp_lists = filter_esp_rules_lists(rule.esp_rules_lists)
          return if filtered_esp_lists.count.zero?
          website_users.each_slice(filtered_esp_lists.count) do |slice|
            slice.each_with_index do |formsite_user, index|
              next unless rule.should_send_now?(formsite_user.created_at)
              params = { affiliate: formsite_user.affiliate }.compact
              esp_list = filtered_esp_lists[index]
              next unless esp_list
              subscription_service_for(esp_list.list_type).new(esp_list.list, params: params, esp_rule: rule).send(:add, formsite_user.user)
            end
          end
        end
      end
  
      private
  
      def rules
        EspRules::Website.includes(source: :formsite_users).where.not(delay_in_hours: 0)
      end
  
      def available_website_users_for(rule)
        rule.website.formsite_users.is_verified
          .joins(:user)
          .where('formsite_users.created_at >= ?', rule.delay_in_hours.hours.ago.beginning_of_hour).distinct
      end
    end
  end
