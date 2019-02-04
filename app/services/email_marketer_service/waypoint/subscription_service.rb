module EmailMarketerService
    module Waypoint
      class SubscriptionService
        attr_reader :params, :account
  
        def initialize(list, params: nil, esp_rule: nil)
          @list = list
          @params = params
          @esp_rule = esp_rule
        end
  
        def add(user, leadgen_rev_site = nil)
          return unless is_valid?(user)
          new_params = params.merge({
                                    xAuthentication: list.account.api_key,
                                    firstname: user&.firstname,
                                    lastname: user&.lastname,
                                    zip: user&.zip,
                                    email: user&.email,
                                    DOB: user&.birthday,
                                    LeadIP: user&.ip,
                                    PostURL: user&.url,
                                    InsertTime: Time.now
                                    })
          client.create_contact(new_params)
          handle_user_record(user)
        rescue => e
          puts "Waypoint ESP adding subscriber error - #{e}".red
        end
  
        private
  
        def client
          return @client if defined?(@client)
          @client = EmailMarketerService::Waypoint::ApiWrapperService.new(account: list.account, params: params)
        end
  
        def handle_user_record(user)
          ExportedLead.find_or_create_by(list_id: list.id, list_type: list.type, linkable: user).update(esp_rule: @esp_rule) if user.is_a?(ActiveRecord::Base)
        end
  
        def is_valid?(user)
          if user.is_a?(ActiveRecord::Base)
            !ExportedLead.where(list_id: list.id, list_type: list.type, linkable: user).exists?
          else
            true
          end
        end
      end
    end
  end