module Sms
  module Yodel
    class SubscriptionService
      attr_reader :params, :account

        States = {  AK: "Alaska",
                      AL: "Alabama",
                      AR: "Arkansas",
                      AS: "American Samoa",
                      AZ: "Arizona",
                      CA: "California",
                      CO: "Colorado",
                      CT: "Connecticut",
                      DC: "District of Columbia",
                      DE: "Delaware",
                      FL: "Florida",
                      GA: "Georgia",
                      GU: "Guam",
                      HI: "Hawaii",
                      IA: "Iowa",
                      ID: "Idaho",
                      IL: "Illinois",
                      IN: "Indiana",
                      KS: "Kansas",
                      KY: "Kentucky",
                      LA: "Louisiana",
                      MA: "Massachusetts",
                      MD: "Maryland",
                      ME: "Maine",
                      MI: "Michigan",
                      MN: "Minnesota",
                      MO: "Missouri",
                      MS: "Mississippi",
                      MT: "Montana",
                      NC: "North Carolina",
                      ND: "North Dakota",
                      NE: "Nebraska",
                      NH: "New Hampshire",
                      NJ: "New Jersey",
                      NM: "New Mexico",
                      NV: "Nevada",
                      NY: "New York",
                      OH: "Ohio",
                      OK: "Oklahoma",
                      OR: "Oregon",
                      PA: "Pennsylvania",
                      PR: "Puerto Rico",
                      RI: "Rhode Island",
                      SC: "South Carolina",
                      SD: "South Dakota",
                      TN: "Tennessee",
                      TX: "Texas",
                      UT: "Utah",
                      VA: "Virginia",
                      VI: "Virgin Islands",
                      VT: "Vermont",
                      WA: "Washington",
                      WI: "Wisconsin",
                      WV: "West Virginia",
                      WY: "Wyoming"
                   }


      
      def initialize(params: {}, account:nil)
        @account = account
        @params = params
              
      end

      def add(user, leadgen_rev_site = nil)
        return unless valid?(user, leadgen_rev_site)    
        new_params = params.merge({
                                    #email: user.try(:email),
                                    #ip: params[:ip],
                                    source_id: leadgen_rev_site.id,
                                    first_name: user&.first_name,
                                    last_name: user&.last_name,
                                    phone: params[:phone],
                                    action_date: params[:date],
                                    #origin: params[:url],
                                    state: States.key(params[:state]),
                                    zip: params[:zip],
                                  })
        client.create_contact(new_params)
        mark_as_saved(user, leadgen_rev_site)
      rescue => e
        puts "Yodel adding subscriber error - #{e}".red
      end

      


      
      private

      def client
        return @client if defined?(@client)
        @client = Sms::Yodel::ApiWrapperService.new(account: account, params: params)
      end

      def valid?(user, leadgen_rev_site)
        if user.is_a?(ActiveRecord::Base)
          !SmsSubscriber.where(provider: 'Yodel', linkable: user, source: leadgen_rev_site).exists?
        else
          true
        end
      end

      def mark_as_saved(user, leadgen_rev_site)
        SmsSubscriber.find_or_create_by(provider: 'Yodel', linkable: user, source: leadgen_rev_site) if user.is_a?(ActiveRecord::Base)
      end
    end
  end
end
