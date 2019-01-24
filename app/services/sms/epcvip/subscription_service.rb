module Sms
  module Epcvip
    class SubscriptionService
      attr_reader :params, :account

      STATES = {
        AK: "Alaska",
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
                                    email: user.try(:email),
                                    ipaddress: params[:ip],
                                    firstName: user&.first_name,
                                    lastName: user&.last_name,
                                    phoneMobile: params[:phone],
                                    tcpa: 1,
                                    optinDate: params[:date],
                                    origin: params[:url],
                                    homeState: STATES.key(params[:state]),
                                    type: 1
                                  })
        client.create_contact(new_params)
        mark_as_saved(user, leadgen_rev_site)
      rescue => e
        puts "Epcvip adding subscriber error - #{e}".red
      end

      private

      def client
        return @client if defined?(@client)
        @client = Sms::Epcvip::ApiWrapperService.new(account: account, params: params)
      end

      def valid?(user, leadgen_rev_site)
        if user.is_a?(ActiveRecord::Base)
          !SmsSubscriber.where(provider: 'Epcvip', linkable: user, source: leadgen_rev_site).exists?
        else
          true
        end
      end

      def mark_as_saved(user, leadgen_rev_site)
        SmsSubscriber.find_or_create_by(provider: 'Epcvip', linkable: user, source: leadgen_rev_site) if user.is_a?(ActiveRecord::Base)
      end
    end
  end
end
