module EmailMarketerService
  module Converters
    class AweberToMaropost
      attr_reader :service
      attr_accessor :converted_leads

      UserInfo = Struct.new(:email, :first_name, :last_name)

      def initialize(maropost_list: nil)
        @service = EmailMarketerService::Maropost::AddContactsToList.new(list: maropost_list)
        @converted_leads = []
      end

      def call
        source_leads.map do |lead|
          name = lead.full_name.partition(' ')
          if service.add(UserInfo.new(lead.email, name.first, name.last))
            lead.touch(:converted_at)
            converted_leads << lead
          end
        end
        converted_leads.count
      end

      private

      def source_leads
        Leads::AweberToMaropost.not_converted
      end
    end
  end
end
