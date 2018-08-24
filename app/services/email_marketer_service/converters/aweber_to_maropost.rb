module EmailMarketerService
  module Converters
    class AweberToMaropost
      attr_reader :service
      attr_accessor :converted_lead_ids

      UserInfo = Struct.new(:email, :first_name, :last_name)

      def initialize(maropost_list:, ids:)
        @service = EmailMarketerService::Maropost::AddContactsToList.new(list: maropost_list)
        @lead_ids = ids
        @converted_lead_ids = []
      end

      def call
        source_leads.map do |lead|
          name = lead.full_name.partition(' ')
          if service.add(UserInfo.new(lead.email, name.first, name.last))
            converted_lead_ids << lead.id
          end
        end
        Leads::AweberToMaropost.where(id: converted_lead_ids).update_all(converted_at: Time.current)
        converted_lead_ids.count
      end

      private

      def source_leads
        Leads::AweberToMaropost.not_converted.where(id: @lead_ids)
      end
    end
  end
end
